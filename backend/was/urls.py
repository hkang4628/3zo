"""config URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path
from . import views

urlpatterns = [
    path('', views.health_check, name='health_check'),
    path('signup/', views.signup, name='signup'),
    path('login/', views.login, name='login'),
    path('contest_list/', views.contest_list, name='contest_list'),
    path('contest_detail/', views.contest_detail, name='contest_detail'),
    path('upload/', views.upload, name='upload'),
    # path('upload/<idx>/image/', views.image, name='image'),
]
