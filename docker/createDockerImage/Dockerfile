FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

RUN pip3 install flask

COPY app.py /opt/app.py

ENTRYPOINT [FLASK_APP=/opt/app.py flask run --host=0.0.0.0]


