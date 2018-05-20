1. 更改密码
```json
{
    "old_password": $("#old-password").val(),
    "new_password1": $("#new-password-1").val(),
    "new_password2": $("#new-password-2").val(),
}
```

2. 忘记密码
```json
{
    "username": $("#liucl-auth-forgetpassword-username").val(),
    "email": $("#liucl-auth-forgetpassword-email").val(),
}
```

3. 登录
{
    "username": $("#liucl-auth-login-username").val(),
    "password": $("#liucl-auth-login-password").val()
}


4. 消息
{
    "notification_id":$(this).attr("value")
}

5. 注册
{
    "username": $("#liucl-auth-register-username").val(),
    "email": $("#liucl-auth-register-email").val(),
    "password1": $("#liucl-auth-register-password1").val(),
    "password2": $("#liucl-auth-register-password2").val(),
}

6. 重置密码
{
    "uidb64": "{{uidb64}}",
    "token": "{{token}}",
    "new_password1": $("#liucl-auth-resetpassword-password1").val(),
    "new_password2": $("#liucl-auth-resetpassword-password2").val(),
}