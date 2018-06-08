# vi: ft=nginx
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name

# http://(www)?.example.com -> https://example.com
# this avoids http://www -> https://www -> https://
server {
  listen 80;
  listen [::]:80;
  server_name example.com www.example.com;
  return 301 https://example.com$request_uri;
}

# https://www.example.com -> https://example.com
server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name www.example.com;
  include h5bp/directive-only/ssl.conf;
  return 301 https://example.com$request_uri;
}

server {
  # listen 443 ssl http2 deferred;  # for Linux
  # listen [::]:443 ssl http2 deferred;  # for Linux
  listen 443 ssl http2;
  listen [::]:443 ssl http2;

  # The host name to respond to
  server_name example.com;

  ssl_certificate ;     # FIXME
  ssl_certificate_key;  # FIXME

  include h5bp/directive-only/ssl.conf;

  # Path for static files
  root /var/www/example.com/public;

  # Custom 404 page
  error_page 404 /404.html;

  # Include the basic h5bp config set
  include h5bp/basic.conf;
}
