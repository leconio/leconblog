from django.conf.urls import url

from liucl_email.views import EmailView

urlpatterns = [
    url(r'^email$', EmailView.as_view()),
]
