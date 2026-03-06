from django import template
from rehab.models import Blog


def do_blog(parser, token):
    return BlogNode()


class BlogNode(template.Node):
    def render(self, context):
        context['blogs'] = Blog.objects.all()[:4]
        return ''


register = template.Library()
register.tag('get_blog', do_blog)
