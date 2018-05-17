# Create your views here.

import json

import requests
from django.core.exceptions import PermissionDenied
from django.http import HttpResponse
from django.views.generic import TemplateView

from blog.views import BaseMixin
from leconblog import settings


class EmailView(BaseMixin, TemplateView):
    template_name = 'blog/email.html'

    def get_context_data(self, *args, **kwargs):
        context = super(BaseMixin, self).get_context_data(**kwargs)
        user = self.request.user
        if not user.is_authenticated():
            raise PermissionDenied
        return context

    """
        发送邮件
    """

    def post(self, request, *args, **kwargs):
        if not request.user.is_authenticated():
            raise PermissionDenied
        to = request.POST.get('to', '')
        fromName = request.POST.get('fromName', '')
        subject = request.POST.get('subject', '')
        cc = request.POST.get('cc', '')
        bcc = request.POST.get('bcc', '')
        html = request.POST.get('html', '')

        tail = '<a href="%%user_defined_unsubscribe_link%%"> </a>'
        html += tail

        url = "http://api.sendcloud.net/apiv2/mail/send"
        # 不同于登录SendCloud站点的帐号，您需要登录后台创建发信子帐号，使用子帐号和密码才可以进行邮件的发送。
        params = {"apiUser": settings.EMAIL_USER,
                  "apiKey": settings.EMAIL_KEY,
                  "from": fromName + '@' + settings.EMAIL_ADDRESS,
                  "fromname": fromName,
                  "cc": cc,
                  "bcc": bcc,
                  "to": to,
                  "subject": subject,
                  "html": html,
                  "resp_email_id": "true"
                  }

        r = requests.post(url, files={}, data=params)
        dic = json.loads(r.text)
        return HttpResponse(
                json.dumps(dic),
                content_type="application/json"
        )
