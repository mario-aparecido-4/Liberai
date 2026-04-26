from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth.decorators import login_required

def login_view(request):
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            # Aqui está o pulo do gato: mandamos para o roteador, não para a home
            return redirect('roteador')
    else:
        form = AuthenticationForm()
        form.fields['username'].widget.attrs.update({
            'class': 'form-control-custom', 
            'placeholder': '' # Placeholder vazio para ficar igual à imagem
        })
        form.fields['password'].widget.attrs.update({
            'class': 'form-control-custom',
            'placeholder': ''
        })
    
    return render(request, 'glpi/login.html', {'form': form})

@login_required
def roteador(request):
    """
    Função invisível que verifica quem é o usuário e redireciona.
    """
    user = request.user

    # Verifica se é SUPERVISOR
    # (Certifique-se de criar o grupo 'Supervisores' no Admin do Django depois)
    if user.groups.filter(name='Supervisores').exists():
        # Por enquanto manda para index, mas depois mandará para 'dashboard_supervisor'
        print(f"--- LOGIN: SUPERVISOR {user.username} DETECTADO ---")
        return redirect('index') 
    
    # Se não for supervisor, é ALUNO (comportamento padrão)
    else:
        print(f"--- LOGIN: ALUNO {user.username} DETECTADO ---")
        return redirect('index')