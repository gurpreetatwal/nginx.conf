# vi: ft=nginx

server {

  listen 443 ssl http2;
  listen [::]:443 ssl http2;

  server_name legacyofbhangra.com;

  ssl_certificate /etc/nginx/certs/legacyofbhangra/cert.pem;
  ssl_certificate_key /etc/nginx/certs/legacyofbhangra/key.pem;

  root /home/static/sites/legacyofbhangra.com;
  access_log /var/log/nginx/legacyofbhangra.access.log;
  error_log /var/log/nginx/legacyofbhangra.error.log;

  location / {
    try_files $uri $uri/ /index.html;
  }
}

