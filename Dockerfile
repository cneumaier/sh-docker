from ubuntu:latest

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

RUN apt-get install sudo curl openssh-server python3 python3-dev nano python3-pip libcupti-dev htop apt-transport-https git -y

ADD install_telegraf.sh /mnt
RUN bash /mnt/install_telegraf.sh
RUN rm /etc/telegraf/telegraf.conf
ADD telegraf.conf /etc/telegraf/

ADD req.txt /mnt
RUN pip3 install --upgrade pip
RUN pip3 install -r /mnt/req.txt

RUN useradd -ms /bin/bash sh
RUN adduser sh sudo

RUN rm /usr/local/lib/python3.5/dist-packages/apns.py
ADD apns.py /usr/local/lib/python3.5/dist-packages/

RUN mkdir /etc/sh

USER sh
WORKDIR /home/sh

RUN mkdir sentienthome
RUN mkdir sentienthome/transport
RUN mkdir sentienthome/application

USER root

RUN ln -s /etc/sh /home/sh/sentienthome/project

ENTRYPOINT service ssh start && service telegraf start && /bin/bash