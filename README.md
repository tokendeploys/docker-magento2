# docker-magento2
Dockerfiles for nginx and fpm, specially geared towards running Magento 2.x with Docker. These files are intended for use in a development environment.

# Prerequisites
You should have docker daemon and docker-compose installed.

# Basic usage

Best way to get started, is to pull down the Magento source code onto your local development machine. In this particular example, we are retrieving the latest packaged Magento 2.1 release from Github.

```bash
$ mkdir mage_dev
$ cd mage_dev
$ wget https://github.com/magento/magento2/archive/2.1.7.tar.gz
$ tar -xvzf 2.1.7.tar.gz --strip-components=1
```

Next, it's best to have a look at the system requirements for Magento 2.1 on [devdocs](http://devdocs.magento.com/guides/v2.1/install-gde/system-requirements-tech.html), so we can start building our stack setup in a `docker-compose.yml`. From reading the docs based on version `2.1.7`, we can use latest nginx, PHP >= 7.0.6, and MySQL 5.7. Here is an example of a `docker-compose.yml` file that takes account of these requirements:

```yml
version: '3'

services:

    mysql:
        image: mysql:5.7
        environment:
            - MYSQL_ALLOW_EMPTY_PASSWORD=yes
            - MYSQL_DATABASE=magento
    fpm:
        image: tokendeploys/magento2-fpm:7.0
        volumes:
            - ./:/var/www/magento
        environment:
            - XDEBUG_ENABLE=1
        depends_on:
            - mysql
    nginx:
        image: tokendeploys/magento2-nginx
        volumes:
            - ./:/var/www/magento
        environment:
            - FCGI_HOST=fpm
        depends_on:
            - mysql
            - fpm
```

Save this snippet in a `docker-compose.yml` file in the `mage_dev` directory which also holds the Magento source code. Next up, run `docker-compose up -d`.

```bash
$ docker-compose up -d
Starting magedev_mysql_1
Starting magedev_fpm_1
Starting magedev_nginx_1
```

Compose will run the containers for you in the right order and create a network as well, which each of the containers receiving a IP address on this subnet. A couple of things to notice:
* We are not using a root password for MySQL which is fine, this is for local development only
* We are enabling XDEBUG on the fpm container through the `XDEBUG_ENABLE` environment variable
* We are assigning `fpm` to the `FCGI_HOST` variable which is available since docker-compose will launch all the containers on a `bridge` type network where the names can be used for DNS lookup.

We need to still run some additional installation via composer:

```bash
$ docker exec -u magento magedev_fpm_1 composer --working-dir="/var/www/magento" install
Loading composer repositories with package information
Installing dependencies (including require-dev) from lock file
Package operations: 82 installs, 0 updates, 0 removals
  - Installing magento/magento-composer-installer (0.1.12): Downloading (100%)         
  - Installing braintree/braintree_php (3.7.0): Downloading (100%)         
  - Installing colinmollenhour/cache-backend-file (1.4): Downloading (100%)         
  - Installing colinmollenhour/cache-backend-redis (1.9): Downloading (100%)         
  - Installing magento/zendframework1 (1.12.16-patch3): Downloading (100%)
[...]
```

The above might take a while. If you need interested in dev dependencies, run `composer install` with the `--no-dev` flag.

We are now ready to hit the setup page, but we need to first figure out the IP address of the nginx container:

```bash
$ docker inspect mage_dev_nginx_1 | grep IPA
```

With this ip address, hit the frontend http://<nginx container ip>/setup to go through the setup steps. During those steps, you will be asked for database details. Again, just as with the `FCGI_HOST` param in the nginx configuration, you can use the name of the MySQL container, which in the example above is `mysql`.

## Mailhog
TODO

## Ngrok
TODO

## Swagger UI
TODO
