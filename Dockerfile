FROM bash:5.2.21-alpine3.19

RUN apk update && \
	apk upgrade && \
	echo "y" | apk add --no-cache alpine-sdk && \
	echo "y" | apk add --no-cache zsh && \
	echo "y" | apk add --no-cache valgrind valgrind-dev && \
	echo "y" | apk add --no-cache py3-pip && \
	python -m pip install --upgrade --break-system-packages pip setuptools && \
	python -m pip install --break-system-packages norminette

CMD ["/usr/local/bin/bash"]