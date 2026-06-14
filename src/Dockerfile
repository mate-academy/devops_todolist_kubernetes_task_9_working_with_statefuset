ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} as builder


WORKDIR /app
COPY . .

FROM python:${PYTHON_VERSION} as run

WORKDIR /app

ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        default-libmysqlclient-dev build-essential pkg-config && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /app .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

ENTRYPOINT ["sh", "-c", "python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8080"]
