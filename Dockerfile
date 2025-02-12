# Stage 1: Build Stage
ARG PYTHON_VERSION=3.13
FROM python:${PYTHON_VERSION} AS base

# Set the working directory
WORKDIR /src

#ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
# Now copy the rest of the application
COPY src .

# Stage 2: Run Stage
FROM python:${PYTHON_VERSION} AS run

WORKDIR /src
ENV PYTHONUNBUFFERED=1
# Copy the installed dependencies from builder stage

COPY --from=base /src .
RUN pip install --upgrade pip && pip install -r requirements.txt
## Run database migrations and start the Django application

EXPOSE 8080

# Start the Django application
#ENTRYPOINT ["python", "manage.py", "migrate", "--noinput", "&&", "python", "manage.py", "runserver", "0.0.0.0:8080"]
ENTRYPOINT ["sh", "-c", "python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8080"]