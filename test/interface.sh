#!/bin/bash

red='\033[0;31m'
brightred='\033[1;31m'
green='\033[0;32m'
brightgreen='\033[1;32m'
yellow='\033[0;33m'
brightyellow='\033[1;33m'
pink='\033[38;5;161m'
nocolor='\033[0m'
brightnocolor='\033[1m'

cd pipex/;
echo "";
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

while true;
do
	echo "";
	echo -e "${brightnocolor}Choose the test you want to perform(mandatory/bonus/all). Write exit if you want to exit the test.${nocolor}";
	read test;
	readStatus=$?;
	test=$(echo "$test" | tr '[:upper:]' '[:lower:]');
	if [ "${test}" == "mandatory" ] || [ "${test}" == "bonus" ] || [ "${test}" == "all" ]; then
		break
	elif [ "${test}" == "exit" ] || [ $readStatus -ne 0 ]; then
		echo -e "${green}Test for mandatory and/or bonus part done!!${nocolor}";
		exit 0;
	else
		echo -e "${brightred}Option not valid. Try again please.${nocolor}";
		echo "";
	fi
done
echo "";
while true;
do
	echo -e "${brightnocolor}Choose your shell of preference to use as reference(bash/zsh). Write exit if you want to exit the test.${nocolor}";
	read type_shell;
	readStatus=$?;
	type_shell=$(echo "$type_shell" | tr '[:upper:]' '[:lower:]');
	if [ "${type_shell}" == "bash" ] || [ "${type_shell}" == "zsh" ]; then
		break
	elif [ "${type_shell}" == "exit" ] || [ $readStatus -ne 0 ]; then
		echo -e "${green}Test for mandatory and/or bonus part done!!${nocolor}";
		exit 0;
	else
		echo -e "${brightred}Option not valid. Try again please.${nocolor}";
		echo "";
	fi
done

echo "";
echo -e "${brightnocolor}Starting the test...${nocolor}";
echo "";

if [ "${test}" == "mandatory" ] && [ "${type_shell}" == "bash" ]; then
	/bin/bash mandatory_bash.sh;
fi
if [ "${test}" == "mandatory" ] && [ "${type_shell}" == "zsh" ]; then
	/bin/zsh mandatory_zsh.sh;
fi
if [ "${test}" == "bonus" ] && [ "${type_shell}" == "bash" ]; then
	/bin/bash bonus_bash.sh;
fi
if [ "${test}" == "bonus" ] && [ "${type_shell}" == "zsh" ]; then
	/bin/zsh bonus_zsh.sh;
fi
if [ "${test}" == "all" ] && [ "${type_shell}" == "bash" ]; then
	/bin/bash mandatory_bash.sh;
	/bin/bash bonus_bash.sh;
fi
if [ "${test}" == "all" ] && [ "${type_shell}" == "zsh" ]; then
	/bin/zsh mandatory_zsh.sh;
	/bin/zsh bonus_zsh.sh;
fi