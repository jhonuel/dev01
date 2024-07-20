
#FROM python:3
FROM python:3.8.3-alpine
WORKDIR /app

#COPY requirements.txt ./
#RUN pip install flask --no-cache-dir -r requirements.txt
RUN pip install flask 

COPY . .

#CMD [ "python", "./app.py", ]


#FROM python:3.8.3-alpine

#RUN pip install --upgrade pip

#RUN adduser -D root
#USER root
#WORKDIR /root

#COPY --chown=root:root requirements.txt requirements.txt
#RUN pip install --user -r requirements.txt

#NV PATH="/home/myuser/.local/bin:${PATH}"

#COPY --chown=root:root . .

CMD ["python", "app.py", "app-balancer", "0.0.0.0:5000"]
