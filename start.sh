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
brightnocolor='\033[1m'

if [ $ac -gt 0 ]; then
	echo -e "${red}Invalid ammount of arguments.${nocolor}";
	exit 1;
fi
echo "";
echo -e "${brightnocolor}Welcome to pipexTester developed by ${brightgreen}quiminbano${nocolor}${brightnocolor}, aka. ${brightgreen}corellan${nocolor}${brightnocolor} in HIVE Helsinki(42 Network).${nocolor}";
while true;
do
	echo "";
	echo -e "${brightyellow}This test requires an installation of docker and docker compose to work. Make sure you have them installed in your system.${nocolor}";
	echo "";
	echo -e "${brightnocolor}Would you like to continue to the execution of the test? (y/n)${nocolor}";
	read condition;
	readStatus=$?;
	condition=$(echo "$condition" | tr '[:upper:]' '[:lower:]');
	if [ "${condition}" == "y" ]; then
		break
	elif [ "${condition}" == "n" ] || [ $readStatus -ne 0 ]; then
		echo "";
		echo -e "${brightgreen}All tests done. Hope to see you again!!${nocolor}";
		exit 0;
	else
		echo "";
		echo -e "${brightred}Option not valid. Try again please.${nocolor}";
	fi
done
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

docker-compose up -d;
if [ $? -ne 0 ]; then
	echo -e "${red}The execution of docker-compose failed. Make sure that you have a valid installation of docker in your machine${nocolor}";
	rm -rf temp_files/;
	rm -rf Dockerfile;
	exit 1;
fi
docker-compose exec pipex bash /pipex/interface.sh
docker-compose down
rm -rf temp_files/;
rm -rf Dockerfile;
echo "";
echo -e "${brightgreen}All tests done. Hope to see you again!!${nocolor}";
exit 0;