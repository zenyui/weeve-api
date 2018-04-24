FROM ubuntu:16.04

RUN echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# get python3
RUN apt-get -qq update
RUN apt-get install -y software-properties-common > /dev/null
RUN add-apt-repository ppa:jonathonf/python-3.6 > /dev/null
RUN apt-get -qq update

RUN apt-get install -y \
  build-essential \
  libssl-dev \
  libffi-dev \
  python3.6 \
  python3.6-dev \
  python3-pip

# make environment
RUN python3.6 -m pip install --upgrade pip virtualenv
RUN python3.6 -m pip install virtualenv
RUN virtualenv /app/env -p python3.6
ENV PATH /app/env/bin:$PATH

WORKDIR /app

COPY requirements.txt ./
RUN pip install -q --no-cache-dir -r requirements.txt

# Copy app files
COPY server ./server
COPY server_cli.py ./

RUN python ./server_cli.py nltk -i

ENV FUNNEL_API_CONFIG "/secrets/api-config.yaml"

CMD gunicorn -w 3 -b 0.0.0.0:8080 'rpt_api:create_app()'
