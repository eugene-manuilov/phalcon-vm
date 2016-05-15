#!/usr/bin/env bash

# Zephir
#
# Build and install zephir if it's not built yet
if [[ ! -f /usr/local/bin/zephir ]]; then
    echo "Installing Zephir..."
    git clone https://github.com/phalcon/zephir /tmp/zephir
    cd /tmp/zephir
    ./install -c
fi

# PhalconPHP
#
# Build and install phalcon extension if it isn't built yet
if [[ ! -f /usr/lib/php/20151012/xdebug.so ]]; then
    echo "Installing PhalconPHP..."
    git clone git://github.com/phalcon/cphalcon.git /tmp/cphalcon
    cd /tmp/cphalcon/build
    git checkout origin/2.1.x -b origin/2.1.x
    zephir build —backend=ZendEngine3
fi