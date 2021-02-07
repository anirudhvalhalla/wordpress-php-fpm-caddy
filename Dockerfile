FROM ubuntu:latest

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends bash curl ca-certificates php7.4-fpm php7.4-mbstring php7.4-mysql; \
	rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	{ \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /etc/php/7.4/cli/conf.d/opcache-recommended.ini
RUN { \
		echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
		echo 'display_errors = Off'; \
		echo 'display_startup_errors = Off'; \
		echo 'log_errors = On'; \
		echo 'error_log = /dev/stderr'; \
		echo 'log_errors_max_len = 1024'; \
		echo 'ignore_repeated_errors = On'; \
		echo 'ignore_repeated_source = Off'; \
		echo 'html_errors = Off'; \
	} > /etc/php/7.4/cli/conf.d/error-logging.ini
RUN mkdir -p /var/log/caddy /etc/caddy /var/www/html
RUN curl -sL https://github.com/caddyserver/caddy/releases/download/v2.3.0/caddy_2.3.0_linux_amd64.tar.gz | tar -xz -C /usr/bin/ caddy && curl -sL https://wordpress.org/latest.tar.gz | tar -xz -C /var/www/html && mv /var/www/html/wordpress/* /var/www/html && rmdir /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
COPY docker-start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-start.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["docker-start.sh"]