FROM python:3.9
ADD . /app
WORKDIR /app

COPY requirements.txt ./
COPY manage.py ./
RUN pip install -r requirements.txt

CMD ["python", "manage.py"]