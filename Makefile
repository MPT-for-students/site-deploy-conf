.PHONY: reload-nginx
reload-nginx:
	docker restart mpt-nginx

.PHONY: stop-nginx
stop-nginx:
	docker compose down

.PHONY: start-nginx
start-nginx:
	docker compose up -d

.PHONY: build-nginx
build-nginx:
	docker compose build

.PHONY: get-ssl
get-ssl:
	docker run --rm -v $(pwd)/letsencrypt:/etc/letsencrypt -v $(pwd)/www:/var/www/html certbot/certbot certonly --webroot -w /var/www/html -d example.ru -d www.mpt-site.ru --email example@mail.ru --agree-tos --no-eff-email --force-renewal

