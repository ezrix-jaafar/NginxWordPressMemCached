#https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/master/5/debian-10/Dockerfile
FROM bitnami/wordpress-nginx:latest

ENV WORDPRESS_TABLE_PREFIX=bn_ \
	WORDPRESS_EXTRA_WP_CONFIG_CONTENT="define('WP_CACHE', true);define( 'WP_AUTO_UPDATE_CORE', true );"

# leave the USER 1001 mode, add package, grand right to 1001 and restore the usage of this user
USER root

# now in root user mode, nginx daemon will need to access the phpfpm stuff from root
RUN usermod -aG root daemon && \	
# add memcached package (check: php -i | grep memcache)
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y memcached php-memcached && \
	apt-get autoremove --purge && \
	apt-get clean && \
# change memcached settings
	sed -i 's/-m 64/-m 512/' /etc/memcached.conf && \
# start the service (else won't start; check : ps -eaf | grep memcached)
	sed -i 's/# Load WordPress environment/# Load WordPress environment\\\nservice memcached start/' /opt/bitnami/scripts/wordpress/entrypoint.sh
