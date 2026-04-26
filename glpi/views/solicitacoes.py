from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages # Para dar feedback visual
from ..models import Espaco
from ..forms import SolicitacaoForm

@login_required
def criar_solicitacao(request): # Remova qualquer argumento extra como 'espaco_id'
    
    if request.method == 'POST':
        form = SolicitacaoForm(request.POST)
        if form.is_valid():
            nova_solicitacao = form.save(commit=False)
            nova_solicitacao.solicitante = request.user
            nova_solicitacao.save()
            return redirect('index')
    else:
        form = SolicitacaoForm()

    return render(request, 'glpi/criar_solicitacao.html', {'form': form})