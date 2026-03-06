from django.db import models
from tinymce.models import HTMLField
from imagekit.models import ProcessedImageField
from imagekit.processors import ResizeToFill
# Create your models here.


class Service(models.Model):
    name = models.CharField(max_length=100)
    summary = HTMLField()
    body = HTMLField()
    image = ProcessedImageField(upload_to='services', processors=[ResizeToFill(200, 200)],
                                  format='JPEG',
                                  options={'quality': 100}, blank=True)

    def __str__(self):
        return self.name


class Testimony(models.Model):
    name = models.CharField(max_length=100)
    summary = HTMLField()
    description = HTMLField()
    photo = ProcessedImageField(upload_to='testimonies', processors=[ResizeToFill(256, 256)],
                                  format='JPEG',
                                  options={'quality': 100}, blank=True)

    def __str__(self):
        return self.name

    class Meta:
        verbose_name_plural = 'Testimonies'


class Blog(models.Model):
    title = models.CharField(max_length=100, blank=True)
    picture = ProcessedImageField(upload_to='blogs', processors=[ResizeToFill(200, 200)],
                                  format='JPEG',
                                  options={'quality': 100}, blank=True)
    summary = HTMLField()
    body = HTMLField()
    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class Message(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.EmailField()
    phone = models.CharField(max_length=50)
    message = models.TextField()

    def __str__(self):
        return self.first_name + " " + self.last_name


class Career(models.Model):
    STATUS = (
        ('open', 'Open'),
        ('closed', 'Closed'),

    )
    title = models.CharField(max_length=200, blank=True)
    summary = HTMLField()
    description = HTMLField()
    created = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=STATUS, default='open')

    def __str__(self):
        return self.title
