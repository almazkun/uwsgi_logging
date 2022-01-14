from django.views.generic import TemplateView
from logging import getLogger


logger = getLogger(__name__)

# Create your views here.
class IndexView(TemplateView):
    template_name = "index.html"

    def get(self, request, *args, **kwargs):
        logger.info("Index page requested")
        return super().get(request, *args, **kwargs)
