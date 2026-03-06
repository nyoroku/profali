from django import template
from rehab.models import Service


def do_service(parser, token):
    return ServiceNode()


class ServiceNode(template.Node):
    def render(self, context):
        context['services'] = Service.objects.all()
        return ''


register = template.Library()
register.tag('get_service', do_service)
