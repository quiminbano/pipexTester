FROM alpine:3.19

RUN apk update && \
	apk upgrade && \
	echo "y" | apk add --no-cache alpine-sdk && \
	echo "y" | apk add --no-cache zsh && \
	echo "y" | apk add --no-cache bash && \
	echo "y" | apk add --no-cache valgrind valgrind-dev && \
	echo "y" | apk add --no-cache py3-pip && \
	python -m pip install --upgrade --break-system-packages pip setuptools && \
	python -m pip install --break-system-packages norminette && \
	mkdir pipex

WORKDIR /pipex

COPY ./test .

RUN chmod +x interface.sh && \
	chmod +x mandatory_bash.sh && \
	chmod +x mandatory_zsh.sh && \
	chmod +x bonus_bash.sh && \
	chmod +x bonus_zsh.sh && \
	chmod +x extratests_bash.sh && \
	chmod +x extratests_zsh.sh && \
	chmod +x extratests_bonus_bash.sh && \
	chmod +x extratests_bonus_zsh.sh

CMD ["/bin/bash"]