FROM python:3.10-slim

WORKDIR /workspace
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app ./app
COPY wsgi.py .

EXPOSE 8080
CMD ["gunicorn", "--preload", "-w", "4", "-b", "0.0.0.0:8080", "wsgi:app"]
