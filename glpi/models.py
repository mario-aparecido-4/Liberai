from django.db import models
from django.core.exceptions import ValidationError
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils import timezone
from django.conf import settings


class EntidadeAbstrataBase(models.Model):
    """
    **Classe abstrata base para todas as entidades persistentes do sistema.**

    Centraliza comportamentos comuns de todas as entidades,
    garantindo consistência, rastreabilidade e integridade de dados.

    **Responsabilidades:**
    - Implementar exclusão lógica (soft delete)
    - Registrar auditoria de criação e atualização
    - Garantir validação automática antes da persistência

    **Regras de negócio:**
    - Entidades inativas não devem ser consideradas válidas para operações normais
    - Nenhum registro é removido fisicamente do banco de dados
    - Toda operação de salvamento passa por validação completa (`full_clean()`)

    Attributes:
        ativo (bool): Indica se a entidade está ativa no sistema.
        created_at (datetime): Data e hora de criação do registro.
        updated_at (datetime): Data e hora da última atualização.

    Notes:
        - O método ``save()`` executa automaticamente ``full_clean()``,
          validando campos, regras de domínio e constraints.
        - Operações como ``bulk_create`` e ``update`` **não** disparam
          ``save()`` nem validações.
        - Os métodos ``ativar()`` e ``desativar()`` implementam
          exclusão lógica (soft delete).
    """

    ativo = models.BooleanField(
        default=True, 
        help_text="Indica se a entidade está ativa (exclusão lógica)."
    )

    created_at = models.DateTimeField(
        auto_now_add=True, 
        verbose_name="Criado em", 
        editable=False
    )

    updated_at = models.DateTimeField(
        auto_now=True, 
        verbose_name="Última atualização", 
        editable=False
    )

    def save(self, *args, **kwargs):
        """
        Salva a instância após executar todas as validações do model.

        **Este método garante que:**
        - Campos individuais sejam validados
        - Regras de negócio definidas em ``clean()`` sejam respeitadas
        - Constraints de banco sejam verificadas antes do commit
        """

        self.full_clean()
        super().save(*args, **kwargs)

    def ativar(self):
        """Ativa a entidade no sistema."""
        self.ativo = True
        self.save()
    
    def desativar(self):
        """Desativa a entidade do sistema sem removê-la do banco."""
        self.ativo = False
        self.save()

    class Meta:
        abstract = True




class BloqueiosSolicitacaoAbstrato(EntidadeAbstrataBase):
    """
    **Classe abstrata base para entidades que representam bloqueios e solicitações.**

    Centraliza a lógica comum relacionada aos bloqueios e solicitações, incluindo o
    armazenamento do ```motivo``` da existência das entidades e sua normalização antes da validação.

    Attributes:
        motivo (str): Explicação do motivo do bloqueio/solicitação.
    """

    motivo = models.TextField(
        verbose_name="Motivo", 
        help_text="Explicação do motivo"
    )

    def clean(self):
        """
        Executa validações e normalizações antes da persistência.

        Remove espaços em branco no início e no fim do campo `motivo`,
        garantindo consistência nos dados armazenados.
        """

        super().clean()

        if self.motivo:
            self.motivo = self.motivo.strip()

    class Meta:
        abstract = True




class Espaco(EntidadeAbstrataBase):
    """
    **Espaço físico disponível para uso no sistema.**

    Representa locais como quadras, salas, auditórios ou outros
    ambientes que podem ser utilizados para reservas.

    **Regras de negócio:**
        - O `nome` deve ser único.
        - A `capacidade` mínima é **1** pessoa.
        - A `capacidade` máxima é **10.000** pessoas.
        - Espaços inativos não devem ser considerados disponíveis.

    Attributes:
        nome (str): Nome identificador do espaço.
        descricao (str): Descrição opcional do espaço.
        capacidade (int): Capacidade máxima permitida.

    **Notas**:
        - Campos textuais são normalizados no método `clean()`.
        - Herda controle de ativação lógica de `EntidadeAbstrataBase`.
    """

    nome = models.CharField(
        max_length=100, 
        unique=True, 
        help_text="ex: Quadra Poliesportiva"
    )

    descricao = models.TextField(
        blank=True, 
        null=True, 
        verbose_name="Descrição"
    )

    capacidade = models.PositiveIntegerField(
        validators=[
            MinValueValidator(1), 
            MaxValueValidator(10000)
        ],
        help_text="Capacidade máxima do espaço."
    )

    def __str__(self):
        """
        Retorna o nome do espaço.

        Returns:
            str: `Nome` identificador do espaço.
        """

        return self.nome

    def clean(self):
        """
        Executa validações e normalizações antes da persistência.

        Remove espaços em branco no início e no fim dos campos
        textuais (`nome` e `descricao`).
        """
        
        super().clean()
        
        if self.nome:
            self.nome = self.nome.strip()

        if self.descricao:
            self.descricao = self.descricao.strip()

    class Meta:
        db_table = "espaco_tb"
        verbose_name = "Espaço"
        verbose_name_plural = "Espaços"




def validar_horario(hora_inicio, hora_fim):
    """
    **Valida a consistência de um intervalo de horário.**

    Garante que o horário de início seja anterior ao horário de fim.

    Args:
        hora_inicio (datetime): Horário inicial do intervalo.
        hora_fim (datetime): Horário final do intervalo.

    Raises:
        ValidationError: Se `hora_inicio` for maior ou igual a `hora_fim`.
    """

    if hora_inicio >= hora_fim:
        raise ValidationError({"hora_fim" : "deve ser maior que hora_inicio"})


class Bloqueio(BloqueiosSolicitacaoAbstrato):
    """
    **Representa um bloqueio de uso de um espaço em um intervalo específico.**

    Impede que um determinado espaço seja utilizado em uma data e
    intervalo de horário definidos.

    **Regras de negócio:**
    - O horário de início deve ser anterior ao horário de término.
    - A data do bloqueio deve ser **igual ou posterior à data atual**.
    - Não pode existir sobreposição de horários para o mesmo espaço na mesma data.
    - Bloqueios idênticos (mesmo espaço, data e horários) são únicos.

    Attributes:
        espaco (Espaco): Espaço físico que será bloqueado.
        data (date): Data em que o bloqueio ocorrerá.
        hora_inicio (time): Horário de início do bloqueio.
        hora_fim (time): Horário de término do bloqueio.
        motivo (str): Motivo do bloqueio (herdado).

    **Nota**: Herda controle de ativação lógica de `EntidadeAbstrataBase`.
    """

    espaco = models.ForeignKey(
        Espaco, 
        on_delete=models.CASCADE, 
        db_column="espaco_id", 
        related_name="bloqueios"
    )
    
    data = models.DateField(
        verbose_name="Data de Bloqueio", 
        help_text="Data que ocorrerá o bloqueio"
    )

    hora_inicio = models.TimeField(verbose_name="Horário de início")
    hora_fim = models.TimeField(verbose_name="Horário de termino")

    def __str__(self):
        """
        Retorna uma representação textual do bloqueio.

        Returns:
            str: `Espaço`, `data` e `intervalo de horário do bloqueio`.
        """

        return f'{self.espaco} [{self.data}: {self.hora_inicio} ~ {self.hora_fim}]'
    
    def clean(self):
        """
        **Executa validações de domínio para o bloqueio.**

        **Valida:**
        - Consistência do intervalo de horário
        - Data não anterior à data atual
        - Ausência de conflitos de horário com outros bloqueios do mesmo espaço na mesma data
        """

        super().clean()

        if not self.data or not self.hora_inicio or not self.hora_fim or not self.espaco_id:
            return
        
        validar_horario(self.hora_inicio, self.hora_fim)

        data_atual = timezone.now().date()

        if self.data < data_atual:
            raise ValidationError({"data" : "deve ser maior ou igual a data atual"})
        
        
        bloqueios_existentes = Bloqueio.objects.filter(
            espaco = self.espaco,
            data = self.data,
            hora_inicio__lt= self.hora_fim,
            hora_fim__gt = self.hora_inicio
        ).exclude(pk = self.pk)
        
        if bloqueios_existentes.exists():
            raise ValidationError({"hora_inicio" : f"Conflito de horário! O espaço está bloqueado das {bloqueios_existentes.first().hora_inicio} às {bloqueios_existentes.first().hora_fim}"})

    class Meta:
        db_table = "bloqueio_tb"
        verbose_name = "Bloqueio"
        verbose_name_plural = "Bloqueios"
        constraints = [models.UniqueConstraint(
            name="bloqueio_unico_exato", 
            fields=["espaco", "data", "hora_inicio", "hora_fim"]
        )]




class BloqueioRecorrente(BloqueiosSolicitacaoAbstrato):
    """
    **Representa um bloqueio recorrente de uso de um espaço.**

    Define bloqueios que se repetem semanalmente em um determinado
    dia da semana e intervalo de horário, independentemente da data.

    É utilizado para impedir o uso contínuo de um espaço em horários
    fixos, como aulas.

    **Regras de negócio:**
    - O horário de início deve ser anterior ao horário de término.
    - Não pode existir sobreposição de horários para o mesmo espaço no mesmo dia da semana.
    - Bloqueios recorrentes idênticos são únicos.

    Attributes:
        espaco (Espaco): Espaço físico que será bloqueado.
        dia_semana (str): Dia da semana em que o bloqueio ocorre.
        hora_inicio (time): Horário de início do bloqueio.
        hora_fim (time): Horário de término do bloqueio.
        motivo (str): Motivo do bloqueio (herdado).
    
    **Nota**: Herda controle de ativação lógica de `EntidadeAbstrataBase`.
    """

    class Semana(models.TextChoices):
        """Dias da semana disponíveis para bloqueio recorrente."""

        SEGUNDA = 'SEGUNDA', 'Segunda'
        TERCA = 'TERCA', 'Terça'
        QUARTA = 'QUARTA', 'Quarta'
        QUINTA = 'QUINTA', 'Quinta'
        SEXTA = 'SEXTA', 'Sexta'
        SABADO = 'SABADO', 'Sábado'
        DOMINGO = 'DOMINGO', 'Domingo'

    espaco = models.ForeignKey(
        Espaco, 
        on_delete=models.CASCADE, 
        db_column="espaco_id",
        related_name="bloqueios_recorrentes"
    
    )

    dia_semana = models.CharField(
        max_length=20, 
        choices=Semana.choices, 
        verbose_name="Dia da semana"
    )

    hora_inicio = models.TimeField(verbose_name="Horário de início")
    hora_fim = models.TimeField(verbose_name="Horário de termino")
    
    def __str__(self):
        """
        Retorna uma representação textual do bloqueio recorrente.

        Returns:
            str: Espaço, dia da semana e intervalo de horário.
        """

        return f'{self.espaco} [{self.dia_semana}: {self.hora_inicio} ~ {self.hora_fim}]'
    
    def clean(self):
        """
        **Executa validações de domínio do bloqueio recorrente.**

        **Valida**:
        - Consistência do intervalo de horário
        - Ausência de conflitos de horário para o mesmo espaço no mesmo dia da semana
        """

        super().clean()

        if not self.dia_semana or not self.hora_inicio or not self.hora_fim or not self.espaco_id:
            return

        validar_horario(self.hora_inicio, self.hora_fim)

        bloqueios_existentes = BloqueioRecorrente.objects.filter(
            espaco = self.espaco,
            dia_semana = self.dia_semana,
            hora_inicio__lt= self.hora_fim,
            hora_fim__gt = self.hora_inicio
        ).exclude(pk = self.pk)
        
        if bloqueios_existentes.exists():
            raise ValidationError({"hora_inicio" : f"Conflito de horário! O espaço está bloqueado das {bloqueios_existentes.first().hora_inicio} às {bloqueios_existentes.first().hora_fim}"})

    class Meta:
        db_table = "bloqueio_recorrente_tb"
        verbose_name = "Bloqueio Recorrente"
        verbose_name_plural = "Bloqueios Recorrentes"
        constraints = [models.UniqueConstraint(name="bloqueio_recorrente_unico_exato", fields=["espaco", "dia_semana", "hora_inicio", "hora_fim"])]




def validar_datas(data_inicio, data_fim):
    """
    **Valida a consistência de um intervalo de datas.**

    Garante que a data inicial seja anterior à data final.

    Args:
        data_inicio (datetime): Data inicial do intervalo.
        data_fim (datetime): Data final do intervalo.

    Raises:
        ValidationError: Se `data_inicio` for maior ou igual a `data_fim`.
    """

    if data_inicio >= data_fim:
        raise ValidationError({"data_fim":"Deve ser posterior à data inicial."})
    

class Solicitacao(BloqueiosSolicitacaoAbstrato):
    """
    **Representa uma solicitação de reserva de um espaço.**

    **Regras de negócio:**
    - A data/hora inicial deve ser anterior à data/hora final.
    - Não pode existir sobreposição com outra solicitação **aprovada**
      para o mesmo espaço.
    - Solicitações possuem um ciclo de vida definido por status.
    - Solicitações inativas não devem ser consideradas válidas.

    **Ciclo de status:**
    - `PENDENTE`: Solicitação aguardando análise.
    - `APROVADO`: Solicitação aprovada e válida.
    - `NEGADO`: Solicitação analisada e negada.
    - `CANCELADO`: Solicitação cancelada pelo solicitante ou sistema.

    Attributes:
        solicitante (User): Usuário que realizou a solicitação.
        espaco (Espaco): Espaço físico solicitado.
        data_inicio (datetime): Início do período solicitado.
        data_fim (datetime): Fim do período solicitado.
        status (str): Status atual da solicitação.
        motivo_status (str): Justificativa da decisão do status.
        analisado_por (User): Usuário responsável pela análise.
        motivo (str): Motivo da solicitação (herdado).

    **Nota**: Herda controle de ativação lógica de `EntidadeAbstrataBase`.
    """

    class StatusSolicitacao(models.TextChoices):
        """Estados possíveis de uma solicitação de reserva."""
        PENDENTE = 'PENDENTE', 'Pendente'
        APROVADO = 'APROVADO', 'Aprovado'
        NEGADO = 'NEGADO', 'Negado'
        CANCELADO = 'CANCELADO', 'Cancelado'

    #   CAMPOS DE NIVEL NORMAL
    solicitante = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        db_column="solicitante_id", 
        related_name='solicitacoes'
    )

    espaco = models.ForeignKey(
        Espaco, 
        on_delete=models.CASCADE, 
        db_column="espaco_id", 
        related_name='solicitacoes'
    
    )

    data_inicio = models.DateTimeField(verbose_name="Início da Reserva")
    data_fim = models.DateTimeField(verbose_name="Fim da Reserva")
    
    #   CAMPOS DE NIVEL GESTOR
    status = models.CharField(
        max_length=20, 
        choices=StatusSolicitacao.choices, 
        default=StatusSolicitacao.PENDENTE
    
    )

    motivo_status = models.TextField(
        blank=True, 
        null=True, 
        verbose_name="Motivo do Status", 
        help_text="Adicione aqui o motivo da resposta (Status)"
    )

    analisado_por = models.ForeignKey(
        settings.AUTH_USER_MODEL, 
        on_delete=models.SET_NULL, 
        null=True, blank=True, #    SOMENTE PARA TESTES --> PEGAR USUARIO QUE RESPONDEU >AUTOMATICAMENTE<
        related_name='aprovacoes',
        verbose_name="Analisado por", 
        editable=True #     SOMENTE PARA TESTES --> AJUSTAR PARA FALSE QUANDO AUTOMATIZAR
    )

    def __str__(self):
        """
        Retorna uma representação textual da solicitação.

        Returns:
            str: `Espaço`, `solicitante` e `status` atual da solicitação.
        """

        return f"{self.espaco} - {self.solicitante} ({self.get_status_display()})"

    def clean(self):
        """
        Executa validações de domínio da solicitação.

        **Valida:**
        - Consistência do intervalo de datas
        - Ausência de conflitos com solicitações **aprovadas** para o mesmo espaço e período
        """
        
        super().clean()
        
        if self.data_inicio and self.data_fim and self.espaco_id:
            validar_datas(self.data_inicio, self.data_fim)

            conflitos = Solicitacao.objects.filter(
                espaco=self.espaco,
                status=self.StatusSolicitacao.APROVADO,
                data_inicio__lt=self.data_fim,
                data_fim__gt=self.data_inicio
            ).exclude(id=self.id)

            if conflitos.exists():
                raise ValidationError({"data_inicio":"Já existe uma reserva APROVADA para este horário e local!"})
            
    class Meta:
        db_table = "solicitacoes_tb"
        ordering = ['-created_at']
        verbose_name = "Solicitação"
        verbose_name_plural = "Solicitações"