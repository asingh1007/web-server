FROM ruby:latest
RUN useradd -u 1234 webserver --home-dir /home/webserver --create-home
USER webserver
COPY http_server.rb /home/webserver/
EXPOSE 80
CMD [ "ruby", "/home/webserver/http_server.rb"]