from django.conf.urls import url

from my_email.views import EmailView

app_name = 'email'
urlpatterns = [
    url(r'^email$', EmailView.as_view()),
]
