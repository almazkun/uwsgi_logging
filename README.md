# uwsgi_logging
uwsgi_logging

# Run it yourself
`Docker` and `make` is required
```bash
make up
make tail
```
Open browser to http://localhost:8080/
```log
[uWSGI] getting INI configuration from uwsgi.ini

==> /var/log/supervisor/uwsgi.log <==
*** WARNING: you are running uWSGI as root !!! (use the --uid flag) ***
your server socket listen backlog is limited to 100 connections
your mercy for graceful operations on workers is 60 seconds
mapped 72920 bytes (71 KB) for 1 cores
*** Operational MODE: single process ***
WSGI app 0 (mountpoint='') ready in 0 seconds on interpreter 0x5557410dd2a0 pid: 9 (default app)
uWSGI running as root, you can use --uid/--gid/--chroot options
*** WARNING: you are running uWSGI as root !!! (use the --uid flag) ***
*** uWSGI is running in multiple interpreter mode ***
spawned uWSGI worker 1 (and the only) (pid: 9, cores: 1)
[2022-01-14 07:09:39,874] INFO: logged.views.Index page requested
14/Jan/2022:07:09:39 +0000 "GET / HTTP/1.1" status=200 res-time=18ms
```


Good day! 

You are right, `logformat` handles only logging of the `uwsgi`.

If you want your Django app to log events you will need to add 2 things:
1. Update `settings.py`:
```py

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    "formatters": {
        "verbose": {
            "format": "[{asctime}] {levelname}: {name}.{message}",
            "style": "{",
        },
    },

    'handlers': {
         "console": {'level': 'DEBUG', "class": "logging.StreamHandler", "formatter": "verbose"},
    },
    "root": {
        "handlers": ["console"],
        "level": "DEBUG",
    },
}
```
2. And add following 2 lines of code to the place you want to log, like here in view:
```py
from django.views.generic import TemplateView
from logging import getLogger # This 


logger = getLogger(__name__) 

# Create your views here.
class IndexView(TemplateView):
    template_name = "index.html"

    def get(self, request, *args, **kwargs):
        logger.info("Index page requested") # And this
        return super().get(request, *args, **kwargs)
``` 
This will render the following:
```log
[2022-01-14 07:09:39,874] INFO: logged.views.Index page requested
14/Jan/2022:07:09:39 +0000 "GET / HTTP/1.1" status=200 res-time=18ms
```
Django docs: https://docs.djangoproject.com/en/4.0/topics/logging/
Check the source code: https://github.com/almazkun/uwsgi_logging
