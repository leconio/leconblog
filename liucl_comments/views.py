# -*- coding: utf-8 -*-
import logging
import datetime
from django.shortcuts import render
from django.http import HttpResponse
from django.views.generic import View
from django.core.exceptions import PermissionDenied

from liucl_auth.models import liuclUser
from liucl_comments.models import Comment
from liucl_system.models import Notification
from blog.models import Article

ArticleModel = Article
# logger
logger = logging.getLogger(__name__)


# Create your views here.

class CommentControl(View):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def post(self, request, *args, **kwargs):
        # 获取当前用户
        user = self.request.user
        is_anonymous = False
        # 获取评论
        text = self.request.POST.get("comment", "")

        # 容错
        en_title = self.kwargs.get('slug', '')
        try:
            # 默认使用pk来索引(也可根据需要使用title,en_title在索引
            article = ArticleModel.objects.get(en_title=en_title)
        except ArticleModel.DoesNotExist:
            logger.error(u'[CommentControl]此文章不存在:[%s]' % en_title)
            raise PermissionDenied

        # 判断当前用户是否是活动的用户
        if not user.is_authenticated():
            logger.error(
                    u'[CommentControl]当前用户非活动用户:[{}]'.format(
                            user.username
                    )
            )
            if not liuclUser.objects.filter(username=user.username):
                if not liuclUser.objects.filter(username=u'yiming'):
                    liuclUser.objects.create(
                            username='yiming'
                    )
                user = liuclUser.objects.filter(username='yiming')[0]
                is_anonymous = True
                # return HttpResponse(u"请登陆！", status=403)
        # 保存评论
        parent = None
        if text.startswith('@['):
            import ast
            parent_str = text[1:text.find(':')]
            parent_id = ast.literal_eval(parent_str)[1]
            text = text[text.find(':') + 2:]
            try:
                parent = Comment.objects.get(pk=parent_id)
                info = u'{}回复了你在 {} 的评论'.format(
                        user.username,
                        parent.article.title
                )
                if not is_anonymous:
                    Notification.objects.create(
                            title=info,
                            text=text,
                            from_user=user,
                            to_user=parent.user,
                            url='/article/' + en_title + '.html'
                    )
            except Comment.DoesNotExist:
                logger.error(u'[CommentControl]评论引用错误:%s' % parent_str)
                return HttpResponse(u"请勿修改评论代码！", status=403)

        if not text:
            return HttpResponse(u"请输入评论内容！", status=403)

        if 'HTTP_X_FORWARDED_FOR' in request.META:
            ip = request.META['HTTP_X_FORWARDED_FOR']
        else:
            ip = request.META['REMOTE_ADDR']

        comment = Comment.objects.create(
                user=user,
                article=article,
                text=text,
                parent=parent,
                isAnonymous=is_anonymous,
                from_ip=u'来自 : ' + ip
        )

        try:
            img = comment.user.img
        except Exception as e:
            img = "http://liucl.qiniudn.com/image/tx/tx-default.jpg"

        print_comment = u"<p>评论：{}</p>".format(text)
        if parent:
            print_comment = u"<div class=\"comment-quote\">\
                                  <p>\
                                      <a>@{}</a>\
                                      {}\
                                  </p>\
                              </div>".format(
                    parent.user.username,
                    parent.text
            ) + print_comment
        # 返回当前评论
        _from = comment.user.username
        if is_anonymous:
            _from = u'来自' + ip
        html = u"<li>\
                    <div class=\"liucl-comment-tx\">\
                        <img src={} width=\"40\"></img>\
                    </div>\
                    <div class=\"liucl-comment-content\">\
                        <a><h1>{}</h1></a>\
                        {}\
                        <p>{}</p>\
                    </div>\
                </li>".format(
                img,
                _from,
                print_comment,
                datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )

        return HttpResponse(html)
