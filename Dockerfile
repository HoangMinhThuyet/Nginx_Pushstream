FROM alpine:latest as dependencies
MAINTAINER thuyethm <thuyet.hoang@hyperlogy.com>

ENV NGINX_VERSION 1.16.0

RUN	apk update		&&	\
	apk add				\
		git			\
		gcc			\
		# binutils-libs		\
		binutils		\
		gmp			\
		isl			\
		libgomp			\
		libatomic		\
		libgcc			\
		openssl			\
		pkgconf			\
		pkgconfig		\
		mpc1			\
		libstdc++		\
		ca-certificates		\
		libssh2			\
		curl			\
		expat			\
		pcre			\
		musl-dev		\
		libc-dev		\
		pcre-dev		\
		zlib-dev		\
		openssl-dev		\
		make


RUN	cd /tmp/ &&	\
	wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz &&	\
	git clone https://github.com/wandenberg/nginx-push-stream-module.git

RUN	cd /tmp &&	\
	tar xzf nginx-${NGINX_VERSION}.tar.gz						&&	\
	cd nginx-${NGINX_VERSION}							&&	\
	./configure \
		--prefix=/opt/nginx \
		--with-http_ssl_module \
		--add-module=../nginx-push-stream-module &&	\
	make &&	\
	make install

FROM alpine:latest
MAINTAINER thuyethm <thuyet.hoang@hyperlogy.com>
RUN apk update && \
	apk add \
				openssl \
				libstdc++ \
				ca-certificates \
				pcre && \
	adduser --disabled-password nginx 
COPY --from=dependencies /opt/nginx /opt/nginx
COPY nginx.conf /opt/nginx/conf/nginx.conf
EXPOSE 80
CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]