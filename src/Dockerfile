
# Stage 1: Build
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} AS builder

WORKDIR /app
COPY . .

# Stage 2: Run
FROM python:${PYTHON_VERSION} AS run

WORKDIR /app

ENV PYTHONUNBUFFERED=1

COPY --from=builder /app /app

# Dependencies for mysqlclient
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

# Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Start Django
ENTRYPOINT ["python", "manage.py", "runserver", "0.0.0.0:8080"]
