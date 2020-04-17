FROM ruby:2.6.6-slim

# Install the software you need
RUN apt-get update \
&& apt-get install -y \
apt-utils \
build-essential \
libpq-dev \
libjpeg-dev \
libpng-dev \
nodejs \
libsqlite3-dev

# Create a directory for your app
RUN mkdir -p /app

# Copy the files needed for the bundle install
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock

# Set the working directory for all following commands
WORKDIR /app

# Install gems
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle install
