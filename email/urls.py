from django.conf.urls import url

from email.views import EmailView

urlpatterns = [
    url(r'^email$', EmailView.as_view()),
]
