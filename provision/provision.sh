#!/bin/bash

install_build_env() {
    sudo apt-get install -y git gcc make re2c php7.0 php7.0-json php7.0-dev php7.0-mysql php7.0-mbstring php7.0-gd php7.0-mcrypt libpcre3-dev
}

build_zephir() {
    git clone https://github.com/phalcon/zephir /tmp/zephir
    cd /tmp/zephir
    sudo ./install -c
}

build_phalcon() {
    git clone git://github.com/phalcon/cphalcon.git /tmp/cphalcon
    cd /tmp/cphalcon/build
    git checkout origin/2.1.x -b origin/2.1.x
    sudo zephir build —backend=ZendEngine3
}

install_build_env
build_zephir
build_phalcon