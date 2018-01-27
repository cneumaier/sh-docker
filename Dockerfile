from ubuntu:latest

RUN apt-get update && apt-get upgrade -y 

RUN apt-get install sudo curl openssh-server python3 python3-dev nano python3-pip libcupti-dev htop apt-transport-https git -y

RUN apt-get update && apt-get install sshpass apache2 unzip -y
RUN apt-get -y install tzdata && ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

ADD install_telegraf.sh /mnt
RUN bash /mnt/install_telegraf.sh
RUN rm /etc/telegraf/telegraf.conf
ADD telegraf.conf /etc/telegraf/

ADD install_ui5.sh /mnt
RUN bash /mnt/install_ui5.sh
ADD index.html /var/www/html/

ADD req.txt /mnt
RUN pip3 install --upgrade pip
RUN pip3 install -r /mnt/req.txt

RUN useradd -ms /bin/bash sh
RUN adduser sh sudo

RUN echo sh:shserver | chpasswd
RUN echo root:shserver | chpasswd

RUN rm /usr/local/lib/python3.5/dist-packages/apns.py
ADD apns.py /usr/local/lib/python3.5/dist-packages/

RUN mkdir /etc/sh

USER sh
WORKDIR /home/sh

RUN mkdir sentienthome
RUN mkdir sentienthome/transport
RUN mkdir sentienthome/application
RUN mkdir sentienthome/build
RUN mkdir sentienthome/launcher
RUN mkdir sentienthome/docs

RUN git clone http://build_bot:NinA91git@gitlab.unifiedneumaier.com:30000/sentient-home/sh-launcher.git sentienthome/launcher


USER root

RUN ln -s /etc/sh /home/sh/sentienthome/project

EXPOSE 10001
EXPOSE 10002
EXPOSE 22
EXPOSE 80

ENTRYPOINT service ssh start && service telegraf start && service apache2 start && /bin/bash