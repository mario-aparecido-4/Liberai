from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from ..models import Solicitacao # Importante: confira se o import do Model está correto

@login_required
def criar_solicitacao(request):
    """
    Página de Criação de Solicitação.
    """
    return render(request, 'glpi/criar_solicitacao.html')

@login_required
def index(request):
    # CORREÇÃO: Usando 'solicitante' em vez de 'aluno'
    # E 'created_at' em vez de 'criado_em' (baseado no seu erro)
    solicitacoes = Solicitacao.objects.filter(solicitante=request.user).order_by('-created_at')

    context = {
        'solicitacoes': solicitacoes
    }

    return render(request, 'glpi/index.html', context)