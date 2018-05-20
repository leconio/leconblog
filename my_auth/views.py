# -*- coding: utf-8 -*-
import base64
import json
import logging
import os
import time

from PIL import Image
from django.conf import settings
from django.contrib import auth
from django.contrib.auth.forms import PasswordChangeForm, SetPasswordForm
from django.contrib.auth.tokens import default_token_generator
from django.contrib.sites.shortcuts import get_current_site
from django.core.exceptions import PermissionDenied
from django.core.mail import send_mail
from django.http import HttpResponse, Http404
from django.utils.http import (urlsafe_base64_decode)

from my_admin.models import Notification
from my_auth.forms import MyUserCreationForm, MyPasswordRestForm
from my_auth.models import MyUser

logger = logging.getLogger(__name__)


# Create your views here.
def user_control(request, *args, **kwargs):
    # 获取要对用户进行什么操作
    slug = kwargs.get('slug')

    if slug == 'login':
        return login(request)
    elif slug == "logout":
        return logout(request)
    elif slug == "register":
        return register(request)
    elif slug == "changepassword":
        return changepassword(request)
    elif slug == "forgetpassword":
        return forgetpassword(request)
    elif slug == "changetx":
        return changetx(request)
    elif slug == "resetpassword":
        return resetpassword(request)
    elif slug == "notification":
        return notification(request)

    raise PermissionDenied


def login(request):
    username = request.POST.get("username", "")
    password = request.POST.get("password", "")
    user = auth.authenticate(username=username, password=password)

    errors = []

    if user is not None:
        auth.login(request, user)
    else:
        errors.append(u"密码或者用户名不正确")

    mydict = {"errors": errors}
    return HttpResponse(
        json.dumps(mydict),
        content_type="application/json"
    )


def logout(request):
    if not request.user.is_authenticated():
        logger.error(u'[UserControl]用户未登陆')
        raise PermissionDenied
    else:
        auth.logout(request)
        return HttpResponse('OK')


def register(request):
    username = request.POST.get("username", "")
    password1 = request.POST.get("password1", "")
    password2 = request.POST.get("password2", "")
    email = request.POST.get("my_email", "")

    form = MyUserCreationForm(request.POST)

    errors = []
    # 验证表单是否正确
    if form.is_valid():
        current_site = get_current_site(request)
        site_name = current_site.name
        domain = current_site.domain
        title = u"欢迎来到 {} ！".format(site_name)
        message = "".join([
            u"你好！ {} ,感谢注册 {} ！\n\n".format(username, site_name),
            u"请牢记以下信息：\n",
            u"用户名：{}\n".format(username),
            u"邮箱：{}\n".format(email),
            u"网站：http://{}\n\n".format(domain),
        ])
        from_email = None
        try:
            send_mail(title, message, from_email, [email])
        except Exception as e:
            logger.error(
                u'[UserControl]用户注册邮件发送失败:[{}]/[{}]'.format(
                    username, email
                )
            )
            return HttpResponse(u"发送邮件错误!\n注册失败", status=500)

        new_user = form.save()
        user = auth.authenticate(username=username, password=password2)
        auth.login(request, user)
    else:
        # 如果表单不正确,保存错误到errors列表中
        for k, v in form.errors.items():
            # v.as_text() 详见django.forms.util.ErrorList 中
            errors.append(v.as_text())
        mydict = {"errors": errors}
        return HttpResponse(
            json.dumps(mydict),
            content_type="application/json"
        )
    return HttpResponse(u'暂时未开放注册', status=403)


def changepassword(request):
    if not request.user.is_authenticated():
        logger.error(u'[UserControl]用户未登陆')
        raise PermissionDenied

    form = PasswordChangeForm(request.user, request.POST)

    errors = []
    # 验证表单是否正确
    if form.is_valid():
        user = form.save()
        auth.logout(request)
    else:
        # 如果表单不正确,保存错误到errors列表中
        for k, v in form.errors.items():
            # v.as_text() 详见django.forms.util.ErrorList 中
            errors.append(v.as_text())

    mydict = {"errors": errors}
    return HttpResponse(
        json.dumps(mydict),
        content_type="application/json"
    )


def forgetpassword(request):
    form = MyPasswordRestForm(request.POST)

    errors = []

    # 验证表单是否正确
    if form.is_valid():
        token_generator = default_token_generator
        from_email = None
        opts = {
            'token_generator': token_generator,
            'from_email': from_email,
            'request': request,
        }
        user = form.save(**opts)

    else:
        # 如果表单不正确,保存错误到errors列表中
        for k, v in form.errors.items():
            # v.as_text() 详见django.forms.util.ErrorList 中
            errors.append(v.as_text())
        mydict = {"errors": errors}
        return HttpResponse(
            json.dumps(mydict),
            content_type="application/json"
        )


def resetpassword(request):
    uidb64 = request.POST.get("uidb64", "")
    token = request.POST.get("token", "")
    password1 = request.POST.get("password1", "")
    password2 = request.POST.get("password2", "")

    try:
        uid = urlsafe_base64_decode(uidb64)
        user = MyUser._default_manager.get(pk=uid)
    except (TypeError, ValueError, OverflowError, MyUser.DoesNotExist):
        user = None

    token_generator = default_token_generator

    if user is not None and token_generator.check_token(user, token):
        form = SetPasswordForm(user, request.POST)
        errors = []
        if form.is_valid():
            user = form.save()
        else:
            # 如果表单不正确,保存错误到errors列表中
            for k, v in form.errors.items():
                # v.as_text() 详见django.forms.util.ErrorList 中
                errors.append(v.as_text())

        mydict = {"errors": errors}
        return HttpResponse(
            json.dumps(mydict),
            content_type="application/json"
        )
    else:
        logger.error(
            u'[UserControl]用户重置密码连接错误:[{}]/[{}]'.format(
                uid64, token
            )
        )
        return HttpResponse(
            u"密码重设失败!\n密码重置链接无效，可能是因为它已使用。可以请求一次新的密码重置.",
            status=403
        )


def changetx(request):
    if not request.user.is_authenticated():
        logger.error(u'[UserControl]用户未登陆')
        raise PermissionDenied

    # 本地保存头像
    data = request.POST['tx']
    if not data:
        logger.error(
            u'[UserControl]用户上传头像为空:[%s]'.format(
                request.user.username
            )
        )
        return HttpResponse(u"上传头像错误", status=500)

    imgData = base64.b64decode(data)

    filename = "tx_100x100_{}.jpg".format(request.user.id)
    filedir = "my_auth/static/tx/"
    static_root = getattr(settings, 'STATIC_ROOT', None)
    if static_root:
        filedir = os.path.join(static_root, 'tx')
    if not os.path.exists(filedir):
        os.makedirs(filedir)

    path = os.path.join(filedir, filename)

    file = open(path, "wb+")
    file.write(imgData)
    file.flush()
    file.close()

    # 修改头像分辨率
    im = Image.open(path)
    out = im.resize((100, 100), Image.ANTIALIAS)
    out.save(path)

    # 选择上传头像到七牛还是本地
    try:
        # 上传头像到七牛
        import qiniu

        qiniu_access_key = settings.QINIU_ACCESS_KEY
        qiniu_secret_key = settings.QINIU_SECRET_KEY
        qiniu_bucket_name = settings.QINIU_BUCKET_NAME

        assert qiniu_access_key and qiniu_secret_key and qiniu_bucket_name
        q = qiniu.Auth(qiniu_access_key, qiniu_secret_key)

        key = filename
        localfile = path

        mime_type = "text/plain"
        params = {'x:a': 'a'}

        token = q.upload_token(qiniu_bucket_name, key)
        ret, info = qiniu.put_file(token, key, localfile,
                                   mime_type=mime_type, check_crc=True)

        # 图片连接加上 v?时间  是因为七牛云缓存，图片不能很快的更新，
        # 用filename?v201504261312的形式来获取最新的图片
        request.user.img = "http://{}/{}?v{}".format(
            settings.QINIU_URL,
            filename,
            time.strftime('%Y%m%d%H%M%S')
        )
        request.user.save()

        # 验证上传是否错误
        if ret['key'] != key or ret['hash'] != qiniu.etag(localfile):
            logger.error(
                u'[UserControl]上传头像错误：[{}]'.format(
                    request.user.username
                )
            )
            return HttpResponse(u"上传头像错误", status=500)

        return HttpResponse(u"上传头像成功!\n(注意有10分钟缓存)")

    except Exception as e:
        request.user.img = "/static/tx/" + filename
        request.user.save()

        # 验证上传是否错误
        if not os.path.exists(path):
            logger.error(
                u'[UserControl]用户上传头像出错:[{}]'.format(
                    request.user.username
                )
            )
            return HttpResponse(u"上传头像错误", status=500)

        return HttpResponse(u"上传头像成功!\n(注意有10分钟缓存)")


def notification(request):
    if not request.user.is_authenticated():
        logger.error(u'[UserControl]用户未登陆')
        raise PermissionDenied

    notification_id = request.POST.get("notification_id", "")
    notification_id = int(notification_id)

    notification = Notification.objects.filter(
        pk=notification_id
    ).first()

    if notification:
        notification.is_read = True
        notification.save()
        mydict = {"url": notification.url}
        print(mydict)
    else:
        mydict = {"url": '#'}

    return HttpResponse(
        json.dumps(mydict),
        content_type="application/json"
    )
