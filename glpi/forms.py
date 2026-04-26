from django import forms
from .models import Solicitacao, Espaco # Importe o Espaco se necessário

class SolicitacaoForm(forms.ModelForm):
    class Meta:
        model = Solicitacao
        # Ordem exata que vamos renderizar no HTML
        fields = ['motivo', 'espaco', 'data_inicio', 'data_fim']
        
        widgets = {
            'motivo': forms.TextInput(attrs={'class': 'custom-input', 'placeholder': 'Ex: Treino de Futsal'}),
            'espaco': forms.Select(attrs={'class': 'custom-input'}),
            'data_inicio': forms.DateTimeInput(attrs={'class': 'custom-input', 'type': 'datetime-local'}),
            'data_fim': forms.DateTimeInput(attrs={'class': 'custom-input', 'type': 'datetime-local'}),
        }
        
    def __init__(self, *args, **kwargs):
        super(SolicitacaoForm, self).__init__(*args, **kwargs)
        # Removemos labels automáticos para controlar melhor no HTML se quiser
        # ou apenas personalizamos o texto
        self.fields['espaco'].queryset = Espaco.objects.all() # Garante que aparecem as quadras