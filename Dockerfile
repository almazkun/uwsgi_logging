FROM python:buster

WORKDIR /home/users

RUN apt-get update && apt-get -y upgrade

ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1

RUN pip3 install --upgrade pip

RUN pip3 install pipenv

COPY ./Pipfile .

COPY ./Pipfile.lock .

RUN pipenv install --deploy --system --ignore-pipfile

COPY . .

RUN apt-get install -y supervisor

COPY ./supervisord.conf /etc/supervisor/supervisord.conf

CMD ["/usr/bin/supervisord"]
