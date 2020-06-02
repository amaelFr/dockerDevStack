FROM nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf.bk

COPY start.sh start.sh

RUN chmod 500 start.sh

ENTRYPOINT [ "./start.sh" ]