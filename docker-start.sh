set -e
echo -e ":$CADDY_PORT {\n\troot * /var/www/html\n\tfile_server\n\tlog {\n\t\toutput file /var/log/caddy/access.log {\n\t\t\troll_size 3MiB\n\t\t\troll_keep 5\n\t\t\troll_keep_for 48h\n\t\t}\n\t\tformat console\n\t}\n\tencode gzip zstd\n\tphp_fastcgi unix//run/php/php7.4-fpm.sock\n\ttls internal\n\n}\n" > /etc/caddy/Caddyfile
exec php-fpm7.4 &
exec /usr/bin/caddy run --config /etc/caddy/Caddyfile