FROM nginx:alpine-perl
EXPOSE 80
EXPOSE 443
RUN apk --update --no-cache add nodejs git bash && npm install -g bower

ENV BOWER_DIRECTORY=/run/bower
RUN mkdir $BOWER_DIRECTORY
WORKDIR $BOWER_DIRECTORY
COPY ./bower.json $BOWER_DIRECTORY/bower.json
COPY ./bower_bash.sh $BOWER_DIRECTORY/bower_bash.sh
RUN /bin/bash bower_bash.sh

COPY ./nginx.conf /etc/nginx/nginx-template.conf
COPY ./cors_support /etc/nginx/cors_support
COPY ./test.html $BOWER_DIRECTORY/test.html
CMD ["/bin/bash", "-c", "envsubst < /etc/nginx/nginx-template.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]