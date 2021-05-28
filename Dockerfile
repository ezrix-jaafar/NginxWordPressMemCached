#https://github.com/bitnami/bitnami-docker-wordpress-nginx/blob/master/5/debian-10/Dockerfile
FROM bitnami/wordpress-nginx:latest

ENV WORDPRESS_TABLE_PREFIX=bn_ \
	WORDPRESS_EXTRA_WP_CONFIG_CONTENT="define('WP_CACHE', true);"

# leave the USER 1001 mode, add package, grand right to 1001 and restore the usage of this user
USER root

# now in root user mode, nginx daemon will need to access the phpfpm stuff from root
RUN usermod -aG root daemon
	
# add memcached package
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y memcached php-memcached && \
	apt-get autoremove && \
	service memcached start
