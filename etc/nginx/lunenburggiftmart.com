upstream lunenburggiftmart {
	server 127.0.0.1:8080;
}

server {
	listen 80;
	server_name lunenburggiftmart.com www.lunenburggiftmart.com;
	root /var/www/lunenburggiftmart.com/public;

    # Dynamic content, forward to hypnotoad
    location / {
        proxy_pass http://lunenburggiftmart;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /img/ {
        expires max;
    }

    location /js/ {
        expires max;
    }

    location /css/ {
        expires max;
    }

}
