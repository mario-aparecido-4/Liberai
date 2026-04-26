from django.contrib import admin
from .models import Espaco, Bloqueio, BloqueioRecorrente, Solicitacao

admin.site.register(Bloqueio)

admin.site.register(BloqueioRecorrente)

@admin.register(Espaco)
class EspacoAdmin(admin.ModelAdmin):
    list_display = ('nome', 'capacidade', 'ativo')
    list_filter = ('ativo',)
    search_fields = ('nome',)

@admin.register(Solicitacao)
class SolicitacaoAdmin(admin.ModelAdmin):
    # O que aparece na tabela principal
    list_display = ('id', 'espaco', 'solicitante', 'data_inicio', 'status', 'updated_at')
    
    # Links clicáveis na tabela
    list_display_links = ('id', 'espaco')
    
    # Filtros laterais (essenciais para gestão)
    list_filter = ('status', 'espaco', 'data_inicio')
    
    # Barra de busca (busca por nome do usuário ou do espaço)

    search_fields = ('solicitante__email', 'solicitante__nome', 'espaco__nome', 'motivo')

    #   date_hierarchy = 'data_inicio'
    
    # Campos que ninguém pode editar na mão (segurança)
    readonly_fields = ('created_at', 'updated_at')

    # Organização visual do formulário de edição
    fieldsets = (
        ('Dados da Solicitação', {
            'fields': ('solicitante', 'espaco', 'motivo', ('data_inicio', 'data_fim'))
        }),
        ('Área Administrativa (Direção)', {
            'fields': ('status', 'motivo_status', 'analisado_por'),
            'classes': ('collapse',), # Deixa essa área recolhida por padrão (opcional)
        }),
        ('Auditoria', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',), # Esconde para não poluir
        }),
    )

    # Dica: Preencher automaticamente o "aprovado_por" com o usuário logado
    def save_model(self, request, obj, form, change):
        # Se o status mudou para algo que não seja pendente e não tem aprovador...
        if obj.status != 'PENDENTE' and not obj.analisado_por:
            obj.analisado_por = request.user
        super().save_model(request, obj, form, change)