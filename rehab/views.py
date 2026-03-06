from django.views.generic import ListView, DetailView, FormView
from .models import Service, Blog, Career
from django.shortcuts import render, redirect
from django.contrib import messages
from .forms import MessageForm


class ServiceDetailView(DetailView):
    model = Service
    template_name = 'rehab/service_detail.html'
    context_object_name = 'service'


class BlogListView(ListView):
    model = Blog
    template_name = 'rehab/blog_list.html'
    context_object_name = 'blogs'


class BlogDetailView(DetailView):
    model = Blog
    template_name = 'rehab/blog_detail.html'
    context_object_name = 'blog'


class CareerListView(ListView):
    model = Career
    template_name = 'rehab/career_list.html'
    context_object_name = 'careers'


class CareerDetailView(DetailView):
    model = Career
    template_name = 'rehab/career_detail.html'
    context_object_name = 'career'


def index(request):
    return render(request, 'index.html')


class MessageView(FormView):
    template_name = 'rehab/message_form.html'
    form_class = MessageForm

    def form_valid(self, form):
        message = form.save(commit=False)

        message.save()
        messages.success(self.request, "Message successfully Sent")
        return redirect('rehab:index')


def about(request):
    return render(request, 'rehab/about.html')