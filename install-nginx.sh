#!/bin/bash

# Detect distribution
detect_distro() {
    if [ -f "/etc/os-release" ]; then
        # Modern Linux distributions
        source /etc/os-release
        echo "$ID"
    elif [ -f "/etc/redhat-release" ]; then
        # RHEL-based systems
        echo "rhel"
    elif [ -f "/etc/debian_version" ]; then
        # Debian-based systems
        echo "debian"
    else
        echo "unknown"
    fi
}

# Install nginx
install_nginx() {
    local distro=$(detect_distro)
    
    case $distro in
        debian|ubuntu)
            sudo apt-get update -qq
            sudo apt-get install -y nginx
            ;;
        rhel|centos|fedora)
            sudo dnf install -y nginx
            ;;
        arch|manjaro)
            sudo pacman -S --noconfirm nginx
            ;;
        *)
            echo "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

# Configure nginx
configure_nginx() {
    # Create backup of default config
    sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
    
    # Create basic configuration
    cat > /etc/nginx/nginx.conf << 'EOF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;
    gzip_disable "msie6";
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
            try_files $uri $uri/ =404;
        }
    }
}
EOF
}

verify_config_restart() {
    # Verify nginx configuration
    sudo nginx -t

    # Reload nginx if configuration is valid
    sudo systemctl reload nginx
    sudo systemctl restart nginx
    sudo systemctl enable nginx
}

# Check if nginx exists
which nginx > /dev/null 2>&1
if [ $? -eq 0 ]; then
    # Verify nginx is working or not
    nginx -v > /dev/null 2>&1
    if [ $? -eq 0 ]; then  
        # Check service status
        systemctl status nginx > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "Nginx is already installed and working"
        else
            echo "Nginx installed but not working"
            echo "==============================="
            echo "Configuring and restarting Nginx"
            configure_nginx

            # Verify nginx configuration and restart
            verify_config_restart
        fi
    else
        echo "Error: Nginx executable exists but not functional"
        exit 1
    fi
else
    echo "Installing Nginx..."
    
    # Install nginx
    install_nginx
    
    # Configure service
    configure_nginx
    verify_config_restart
    
    
    # Verify installation
    nginx -v > /dev/null 2>&1
    if [ $? -eq 0 ] && [ "$(systemctl is-active nginx)" = "active" ]; then
        echo "Nginx installation completed successfully"
    else
        echo "Error: Nginx installation failed"
        exit 1
    fi
fi