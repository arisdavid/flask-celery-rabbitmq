FROM python:3.6

ENV INSTALL_PATH /flask_celery_rabbitmq
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

CMD gunicorn -b 0.0.0.0:8000 --access-logfile - "wsgi_app:app"


