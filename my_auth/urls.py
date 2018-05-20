from django.conf.urls import url
from . import views

app_name = 'my_auth'
urlpatterns = [
    url(r'^usercontrol/(?P<slug>\w+)$', views.user_control, name="control"),
]
