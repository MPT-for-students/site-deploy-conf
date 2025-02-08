# site-deploy-conf
* Конфигурация деплоя сайта МПТ, для последующего переиспользования

# Инстуркция
* Предупреждаю, что все запуски я делал по заготовленным make сценариям, когда мне нужно было поднять nginx, я писал соотствующую команду `make start-nginx`. Так же, чтоб nginx считал изменения в nginx.conf, при каждом его изменении я запискул `make reload-nginx`
* Так как сайт развёрнут на https, нужно было как-то подписать ssl сертификат на нужный домен. Подписание я делал через docker контейнер certbot (он есть и как просто консольная утилита, но лучше в докере, чтоб осталвять меньше хлама в системе)
* Перед тем, как подписать сертификат необходимо сначала запустить просто nginx, и прокинуть нужные папки для него, чтобы он хотя бы отзывался
    
    Так как в репозитоий я прикрепил ПОЛНУЮ версию docker-compose, уточню что при первоначальной настройке nginx, необходимо отключить certbot в docker-compose, потому что он попросту не запустится, так как у него нету нужных ему сертификатов и прочих данных изначально

    ```
    events {}

    http {
        server {
            listen 80;
            server_name localhost;

            location / {
                root /usr/share/nginx/html;
                index index.html;
            }
        }

        server {
            listen 80;
            server_name example.ru www.example.ru;

            location /.well-known/acme-challenge/ {
                root /var/www/html; 
            }

            location / {
                root /usr/share/nginx/html;
                index index.html;
            }
        }
    }
    ```
    После этого нужно попробовать пингануть http домен сайта

    ```
    curl http://example.ru
    ```

    Если в ответе будет стандартная страничка nginx, то всё сделано правильно и можно продолжать настройку дальше

* Далее я запускал `make get-ssl`, предварительно отредактировав его содержимое

    Если после `make get-ssl` всё тип-топ, то можно дописывать полную конфигурацию nginx c ssl

    ```
    events {}

    http {
        server {
            listen 80;
            server_name localhost;

            location / {
                root /usr/share/nginx/html;
                index index.html;
            }
        }

        server {
            listen 80;
            server_name example.ru www.example.ru;

            location /.well-known/acme-challenge/ {
                root /var/www/html; 
            }

            location / {
                root /usr/share/nginx/html;
                index index.html;
            }
        }

        server {
            listen 443 ssl;
            server_name example.ru www.example.ru;

            ssl_certificate /etc/letsencrypt/live/example.ru/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/example.ru/privkey.pem;

            location / {
                root /usr/share/nginx/html;
                index index.html;
            }
        }
    }
    ```
* Далее можно остановить уже запущенный nginx, и заново запустить весь docker-compose.yaml, чтоб setbot подхватил сертификаты и сразу запустил автоматическое продление ssl

* Теперь можно делать тестовый запрос, проверить работает ли https
    ```
    curl https://exmaple.ru
    ```
    Если в ответе вернулась вёрстка стандартной странички nginx, зачит всё сделано правильно

