# myapp/urls.py
from django.contrib import admin
from django.urls import path
from .views import ServiceDetailView, BlogListView, BlogDetailView, \
    CareerListView, CareerDetailView, MessageView


from . import views


# Customize the site header and title
admin.site.site_header = "Azriel Admin"
admin.site.site_title = "Azriel Admin"

# Customize the index title displayed on the admin homepage
admin.site.index_title = "Azriel Admin"

app_name = 'rehab'
urlpatterns = [


    path('service/<int:pk>/', ServiceDetailView.as_view(), name='service-detail'),
    path('blogs/', BlogListView.as_view(), name='blog-list'),
    path('blog/<int:pk>/', BlogDetailView.as_view(), name='blog-detail'),
    path('careers/', CareerListView.as_view(), name='career-list'),
    path('career/<int:pk>/', CareerDetailView.as_view(), name='career-detail'),
    path('', views.index, name='index'),
    path('about/', views.about, name='about'),
    path('create-message/', MessageView.as_view(), name='message_create'),

]
