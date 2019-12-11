# flask-celery-redis
Example Flask, Celery, Flower and Redis services with Docker

docker-compose.yml file split into the following services
- redis
- website
- celery
- flower

```
version: '3.7'

services:

  redis:
    image: 'redis:5.0.5'
    command: redis-server --requirepass devpassword
    volumes:
      - 'redis:/var/lib/redis/data'
    ports:
      - '6379:6379'

  website:
    build: .
    command: >
      gunicorn -b 0.0.0.0:8000
        --access-logfile -
        --reload
        "src.app:flask_app"
    env_file:
      - '.env'
    volumes:
      - '.:/flask_celery_redis'
    ports:
      - '8000:8000'

  celery:
    build: .
    command: celery worker -A wsgi_app.celery --loglevel=info --pool=solo
    env_file:
      - '.env'
    volumes:
      - '.:/flask_celery_redis'

  flower:
    image: mher/flower
    environment:
      - CELERY_BROKER_URL=redis://:devpassword@redis:6379/0
      - FLOWER_PORT=5555
    ports:
      - 5555:5555

volumes:
  redis:

```

## Instructions
1. Must have docker installed (docker for desktop).
2. CD into the root of the project
3. Create a .env file with the following env variables. Place it in the root directory (same level as docker-compose.yaml).
   ```
   COMPOSE_PROJECT_NAME=flask_celery_redis
   PYTHONUNBUFFERED=true
   ```
4. Build the containers
   ```
   docker-compose up --build
   ```
   
## Website
![Website](https://quantmill.s3.eu-west-2.amazonaws.com/github/flask.PNGG)

## RabbitMQ
![RabbitMQ](https://quantmill.s3.eu-west-2.amazonaws.com/github/rabbitmq.PNG)

## Flower
![Flower](https://quantmill.s3.eu-west-2.amazonaws.com/github/flower.PNG)



