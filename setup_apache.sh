#!/bin/bash

htpasswd -cb /etc/apache2/.htpasswd admin NinA91root
service apache2 restart
