FROM ubuntu
MAINTAINER mwaeckerlin
ENV TERM "xterm"

ENV PASSWORD ""

EXPOSE 80
EXPOSE 443

ADD start.sh /start.sh
RUN apt-get update
RUN apt-get install -y phpldapadmin

CMD /start.sh
