from django.urls import path
from django.contrib.auth.views import LogoutView
from .views import geral, solicitacoes, autenticacao

urlpatterns = [
    path('', geral.index, name='index'),
    path('solicitar/', solicitacoes.criar_solicitacao, name='criar_solicitacao'),
    path('login/', autenticacao.login_view, name='login'),
    path('roteador/', autenticacao.roteador, name='roteador'),
    path('logout/', LogoutView.as_view(next_page='login'), name='logout'),
]