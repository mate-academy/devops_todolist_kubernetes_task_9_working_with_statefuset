ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}-slim AS builder

WORKDIR /app
COPY requirements.txt .

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential pkg-config default-libmysqlclient-dev \
    && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*

FROM python:${PYTHON_VERSION}-slim

WORKDIR /app

ENV PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/* \
    && rm -rf /wheels
COPY . .

ENTRYPOINT ["sh", "-c", "python manage.py migrate && exec python manage.py runserver 0.0.0.0:8080 --noreload"]