from django import template
from rehab.models import Testimony


def do_testimonies(parser, token):
    return TestimonyNode()


class TestimonyNode(template.Node):
    def render(self, context):
        context['testimonies'] = Testimony.objects.all()
        return ''


register = template.Library()
register.tag('get_testimony', do_testimonies)
