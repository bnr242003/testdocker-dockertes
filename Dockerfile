<?php phpinfo();
In the project, create a Dockerfile with the following contents.
FROM php:5.6-apache
COPY index.php /var/www/html/
Test it out!
docker build -t php-hello-world .
docker run -ti -p 10080:80 php-hello-world
