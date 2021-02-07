set -e
echo -e "http://:8080\nroot * /var/www/html\nfile_server\nlog {\n\toutput file /var/log/caddy/access.log {\n\t\troll_size 3MiB\n\t\troll_keep 5\n\t\troll_keep_for 48h\n\t}\n\tformat console\n}\nencode gzip zstd\nphp_fastcgi unix//run/php/php7.4-fpm.sock\ntls internal\n\n}\n" > /etc/caddy/Caddyfile
exec php-fpm7.4 &
exec /usr/bin/caddy run --config /etc/caddy/Caddyfile