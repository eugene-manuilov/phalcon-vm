#!/bin/bash

restart() {
	if service --status-all | grep -Fq ${1}; then
		service ${1} restart
	fi
}

restart nginx
restart varnish
restart php7.0-fpm
restart mysql
restart postgresql
restart mongodb
restart redis-server
restart memcached
restart gearman-job-server
restart rabbitmq-server
restart sphinxsearch