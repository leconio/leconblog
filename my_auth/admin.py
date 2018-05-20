# -*- coding: utf-8 -*-
from django.contrib import admin
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin
from my_auth.models import MyUser
from my_auth.forms import MyUserCreationForm


# Register your models here.

class liuclUserAdmin(UserAdmin):
    add_form = MyUserCreationForm
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'my_email', 'password1', 'password2')
        }),
    )
    fieldsets = (
        (u'基本信息', {'fields': ('username', 'password', 'my_email')}),
        (u'权限', {'fields': ('is_active', 'is_staff', 'is_superuser')}),
        (u'时间信息', {'fields': ('last_login', 'date_joined')}),
    )


admin.site.unregister(Group)
admin.site.register(MyUser, liuclUserAdmin)
