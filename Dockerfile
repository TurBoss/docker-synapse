FROM alpine:edge
MAINTAINER Thibault NORMAND <me@zenithar.org>

# Install python
RUN apk --update add python ca-certificates py-virtualenv py-pip py-setuptools

# Add dependencies
RUN apk add -t build-deps make gcc python-dev musl-dev \
                          libffi-dev openssl-dev \
                          freetype-dev jpeg-dev libwebp-dev tiff-dev \
                          libpng-dev lcms2-dev openjpeg-dev zlib-dev

# Install HomeServer
RUN virtualenv -p python2.7 /app \
    && source /app/bin/activate \
    && CFLAGS="$CFLAGS -L/lib" pip install https://github.com/matrix-org/synapse/tarball/master

# Create default user
RUN addgroup synapse \
    && adduser -s /bin/false -G synapse -S -D synapse

# Cleanup
RUN rm -rf /var/cache/apk/* \
    && apk del build-deps

WORKDIR "/app"
