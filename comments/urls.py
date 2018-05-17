from django.conf.urls import url
from comments.views import CommentControl


urlpatterns = [
        url(r'^comment/(?P<slug>\w+)$', CommentControl.as_view()),
]
