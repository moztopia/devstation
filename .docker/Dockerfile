FROM ubuntu:24.04

# Stop "terminal" errors from appearing in the build logs.
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /app

# # Create a non-root user
# ARG USER_ID=1000
# ARG GROUP_ID=1000
# RUN groupadd -g ${GROUP_ID} vscode
# RUN useradd -m -s /bin/bash -u ${USER_ID} -g vscode vscode

# # Set ownership of /app to the non-root user
# RUN chown -R vscode:vscode /app

# Install system dependencies for both frontend and backend
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    zip \
    unzip \
    nano \
    software-properties-common \
    gnupg \
    libapache2-mod-php \
    php8.3-common \
    php8.3-cli \
    php8.3-mbstring \
    php8.3-bcmath \
    php8.3-fpm \
    php8.3-mysql \
    php8.3-zip \
    php8.3-gd \
    php8.3-curl \
    php8.3-xml \
    nodejs \
    npm \
    gh

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

USER ubuntu

# Keep the container running
CMD ["tail", "-f", "/dev/null"]