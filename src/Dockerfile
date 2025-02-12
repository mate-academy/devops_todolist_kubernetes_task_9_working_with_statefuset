# Stage 1: Build Stage
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} as builder

WORKDIR /app


RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev gcc python3-dev


COPY . .


RUN pip install --upgrade pip && pip install -r requirements.txt
RUN pip install mysqlclient

# Stage 2: Run Stage
FROM python:${PYTHON_VERSION} as run

WORKDIR /app

ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev gcc python3-dev


COPY --from=builder /usr/local/lib/python3.8 /usr/local/lib/python3.8
COPY --from=builder /usr/local/bin /usr/local/bin

COPY . .

ENTRYPOINT ["sh", "-c", "python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8080"]
