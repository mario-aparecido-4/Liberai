from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager



class Role(models.TextChoices):
    NORMAL = 'NORMAL', 'Normal'
    GESTOR = 'GESTOR', 'Gestor'
    

class UsuarioManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields): #Tem a funcao de criar um usuario "normal"
        if not email:
            raise ValueError("email é obrigatório")
        
        email = self.normalize_email(email)

        user = self.model(email=email, **extra_fields) #salva o proprio objeto, porem sem a senha
        user.set_password(password) #a senha é convertida em hash

        user.save(using=self._db)

        return user
    

    def create_superuser(self, email, password=None, **extra_fields): #tem a funcao de criar um superuser
        extra_fields.setdefault('is_staff', True) #acesso ao admin
        extra_fields.setdefault('is_superuser', True) #ignora permissoes e tem acesso total
        extra_fields.setdefault('role', Role.GESTOR) #define todo superuser como gestor

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser precisa ter is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser precisa ter is_superuser=True.')

        return self.create_user(email, password, **extra_fields)




class Usuario(AbstractUser):
    username = None
    email = models.EmailField(unique=True, verbose_name="E-mail Institucional", help_text="Adicione o email institucional")
    nome = models.CharField(max_length=150, verbose_name="Nome Completo", help_text="Adicione o nome completo")
    role = models.CharField(max_length=10, choices=Role.choices, default=Role.NORMAL)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['nome']
    objects = UsuarioManager()

    def __str__(self):
        return self.email
    
    def clean(self):
        if self.nome:
            self.nome = self.nome.strip()
        #   IMPLEMENTAR FUTURAMENTE VALIDACAO DE EMAIL INSTITUCIONAL PQ O ALLAUTH NAO BARRA O ADMIN/
        return super().clean()
    
    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

    class Meta:
        db_table = "usuario_tb"
        verbose_name = "Usuário"
        verbose_name_plural = "Usuários"
