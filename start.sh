#!/bin/bash

ac=$#

red='\033[0;31m'
brightred='\033[1;31m'
green='\033[0;32m'
brightgreen='\033[1;32m'
yellow='\033[0;33m'
brightyellow='\033[1;33m'
pink='\033[38;5;161m'
nocolor='\033[0m'

if [ $ac -gt 2 ]; then
	echo -e "${red}Invalid ammount of arguments.${nocolor}";
	echo -e "${red}Usage:\nbash start.sh type_of_test(optional) shell_of_reference(optional).${nocolor}";
	exit 1;
fi
if [ $ac == 0 ]; then
	options="all";
	typeShell="bash";
elif [ $ac == 1 ]; then
	options="$1";
	typeShell="bash";
else
	options="$1";
	typeShell="$2";
fi
echo -e "${pink}

\$\$\$\$\$\$\$\  \$\$\                            \$\$\$\$\$\$\$\$\                    \$\$\                         
\$\$  __\$\$\ \__|                           \__\$\$  __|                   \$\$ |                        
\$\$ |  \$\$ |\$\$\  \$\$\$\$\$\$\   \$\$\$\$\$\$\  \$\$\   \$\$\ \$\$ | \$\$\$\$\$\$\   \$\$\$\$\$\$\$\ \$\$\$\$\$\$\    \$\$\$\$\$\$\   \$\$\$\$\$\$\  
\$\$\$\$\$\$\$  |\$\$ |\$\$  __\$\$\ \$\$  __\$\$\ \\$\$\ \$\$  |\$\$ |\$\$  __\$\$\ \$\$  _____|\_\$\$  _|  \$\$  __\$\$\ \$\$  __\$\$\ 
\$\$  ____/ \$\$ |\$\$ /  \$\$ |\$\$\$\$\$\$\$\$ | \\$\$\$\$  / \$\$ |\$\$\$\$\$\$\$\$ |\\$\$\$\$\$\$\    \$\$ |    \$\$\$\$\$\$\$\$ |\$\$ |  \__|
\$\$ |      \$\$ |\$\$ |  \$\$ |\$\$   ____| \$\$  \$\$<  \$\$ |\$\$   ____| \____\$\$\   \$\$ |\$\$\ \$\$   ____|\$\$ |      
\$\$ |      \$\$ |\$\$\$\$\$\$\$  |\\$\$\$\$\$\$\$\ \$\$  /\\$\$\ \$\$ |\\$\$\$\$\$\$\$\ \$\$\$\$\$\$\$  |  \\$\$\$\$  |\\$\$\$\$\$\$\$\ \$\$ |      
\__|      \__|\$\$  ____/  \_______|\__/  \__|\__| \_______|\_______/    \____/  \_______|\__|      
              \$\$ |                                                                                
              \$\$ |                                                                                
              \__|                                                                                

${nocolor}";
projectPath="$(pwd)/..";
if [ ! -f "${projectPath}/Makefile" ]; then
	echo -e "${red}Makefile not present in the project's folder${nocolor}";
	exit 1;
fi
if ! grep -q "pipex" "${projectPath}/Makefile"; then
	echo -e "${red}Makefile does't create the binary pipex${nocolor}";
	exit 1;
fi
mkdir temp_files;
rsync -a --no-progress --exclude="$(basename $(pwd))" ../* temp_files/;
if [ $? -ne 0 ]; then
	echo -e "${red}Error copying the project's files into the tester folder. Please install the tool rsync and try again. ${nocolor}";
	exit 1;
fi
caseForDockerfile=""
case "$(echo "${options}" | tr '[:upper:]' '[:lower:]')" in
	"mandatory" )
	caseForDockerfile=$(echo -e ENV TEST="mandatory");
	;;
	"bonus" )
	caseForDockerfile=$(echo -e ENV TEST="bonus");
	;;
	"all" )
	caseForDockerfile=$(echo -e ENV TEST="all");
	;;
	* )
	echo -e "${red}Invalid argument for type_of_test${nocolor}";
	echo -e "${red}possible type_of_test: mandatory, bonus, all.${nocolor}";
	rm -rf temp_files/
	exit 1;
esac
case "$(echo "${typeShell}" | tr '[:upper:]' '[:lower:]')" in
	"bash" )
	caseForDockerfile=$(echo -e ${caseForDockerfile} TYPE_SHELL="bash");
	;;
	"zsh" )
	caseForDockerfile=$(echo -e ${caseForDockerfile} TYPE_SHELL="zsh");
	;;
	* )
	echo -e "${red}Invalid argument for shell_of_reference${nocolor}";
	echo -e "${red}Possibles shell_of_reference: bash, zsh.${nocolor}";
	rm -rf temp_files/
	exit 1;
esac
<< EOF cat > Dockerfile
FROM bash:5.2.21-alpine3.19

RUN apk update && \
	apk upgrade && \
	echo "y" | apk add --no-cache alpine-sdk && \
	echo "y" | apk add --no-cache zsh && \
	echo "y" | apk add --no-cache valgrind valgrind-dev

COPY ./temp_files /pipex

WORKDIR /pipex

COPY ./test .

RUN chmod +x interface.sh && \
	chmod +x mandatory_bash.sh && \
	chmod +x mandatory_zsh.sh && \
	chmod +x bonus_bash.sh && \
	chmod +x bonus_zsh.sh && \
	chmod +x unsetting_bash.sh && \
	chmod +x unsetting_zsh.sh && \
	chmod +x unsetting_bonus_bash.sh && \
	chmod +x unsetting_bonus_zsh.sh

${caseForDockerfile}

CMD ["/usr/local/bin/bash", "interface.sh"]
EOF

<< EOF cat > docker-compose.yml
version: '3.8'

services:
  pipex:
    build: ./
    volumes:
    - ./testValgrind:/pipex/testValgrind
    - ./testValgrind_bonus:/pipex/testValgrind_bonus
EOF

docker-compose up
if [ $? -ne 0 ]; then
	echo -e "${red}The execution of docker-compose failed. Make sure that you have a valid installation of docker in your machine${nocolor}";
	rm -rf temp_files/;
	rm -rf Dockerfile;
	rm -rf docker-compose.yml;
	exit 1;
fi
rm -rf temp_files/;
rm -rf Dockerfile;
rm -rf docker-compose.yml;
exit 0;