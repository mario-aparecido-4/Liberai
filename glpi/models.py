from django.db import models
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError

class Espaco(models.Model):
    nome = models.CharField(max_length=100, help_text="Ex: Quadra Poliesportiva, Auditório")
    descricao = models.TextField(blank=True, null=True, verbose_name="Descrição")
    capacidade = models.IntegerField(help_text="Capacidade máxima de pessoas")
    ativo = models.BooleanField(default=True, help_text="Desmarque se o espaço estiver em reforma")

    def __str__(self):
        return self.nome

    class Meta:
        verbose_name = "Espaço"
        verbose_name_plural = "Espaços"

class Solicitacao(models.Model):
    class StatusSolicitacao(models.TextChoices):
        PENDENTE = 'PENDENTE', 'Pendente'
        APROVADO = 'APROVADO', 'Aprovado'
        NEGADO = 'NEGADO', 'Negado'
        CANCELADO = 'CANCELADO', 'Cancelado'

    solicitante = models.ForeignKey(User, on_delete=models.CASCADE, related_name='solicitacoes')
    espaco = models.ForeignKey(Espaco, on_delete=models.CASCADE, related_name='reservas')

    motivo = models.CharField(max_length=50, help_text="Ex: Futsal, Vôlei, Palestra")
    
    data_inicio = models.DateTimeField(verbose_name="Início da Reserva")
    data_fim = models.DateTimeField(verbose_name="Fim da Reserva")
    
    detalhes = models.TextField(help_text="Como o espaço será usado?")
    
    # Campos Administrativos
    status = models.CharField(
        max_length=20,
        choices=StatusSolicitacao.choices,
        default=StatusSolicitacao.PENDENTE
    )
    observacao_admin = models.TextField(blank=True, null=True, verbose_name="Motivo da Negação/Obs")
    aprovado_por = models.ForeignKey(
        User, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='aprovacoes',
        verbose_name="Analisado por"
    )

    # Auditoria (Logs)
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Criado em")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Última atualização")

    class Meta:
        ordering = ['-created_at']
        verbose_name = "Solicitação"
        verbose_name_plural = "Solicitações"

    def __str__(self):
        return f"{self.espaco} - {self.solicitante} ({self.get_status_display()})"

    def clean(self):
        # Validação para evitar choque de horários
        if self.data_inicio and self.data_fim:
            if self.data_inicio >= self.data_fim:
                raise ValidationError("A data final deve ser posterior à data inicial.")

            conflitos = Solicitacao.objects.filter(
                espaco=self.espaco,
                status=self.StatusSolicitacao.APROVADO,
                data_inicio__lt=self.data_fim,
                data_fim__gt=self.data_inicio
            ).exclude(id=self.id)

            if conflitos.exists():
                raise ValidationError("Já existe uma reserva APROVADA para este horário e local!")