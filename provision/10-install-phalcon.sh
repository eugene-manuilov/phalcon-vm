#!/usr/bin/env bash

# Zephir
#
# Build and install zephir if it's not built yet
if [[ -f /usr/local/bin/zephir ]]; then
    echo "Zephir is already installed"
else
    echo "Installing Zephir..."
    git clone https://github.com/phalcon/zephir /tmp/zephir 2>&1
    cd /tmp/zephir
    sudo ./install -c
fi

# PhalconPHP
#
# Build and install phalcon extension if it isn't built yet
if [[ -f /usr/lib/php/20151012/phalcon.so ]]; then
    echo "PhalconPHP is already installed"
else
    echo "Installing PhalconPHP..."
    git clone git://github.com/phalcon/cphalcon.git /tmp/cphalcon 2>&1
    cd /tmp/cphalcon/
    git checkout origin/2.1.x -b origin/2.1.x 2>&1
    sudo zephir build —backend=ZendEngine3 2>&1
fi