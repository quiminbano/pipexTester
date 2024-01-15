#!/usr/local/bin/bash

red='\033[0;31m'
brightred='\033[1;31m'
green='\033[0;32m'
brightgreen='\033[1;32m'
yellow='\033[0;33m'
brightyellow='\033[1;33m'
pink='\033[38;5;161m'
nocolor='\033[0m'

valgrindConst=200;
pipexInstructions=("./pipex '' '' '' ''" \
					"./pipex '' 'cat' 'cat' ''" \
					"./pipex 'infile' 'cat' 'cat' ''" \
					"./pipex '' 'cat' 'cat' 'outfile'" \
					"./pipex 'infile' '' '' 'outfile'" \
					"./pipex 'infile' 'cat' 'cat' 'outfile'" \
					"./pipex 'infile' './testsegv' './testsegv' 'outfile'" \
					"./pipex 'infile' './myfolder' 'cat' 'outfile'" \
					"./pipex 'infile' 'cat' './myfolder' 'outfile'" \
					"./pipex 'infile' '/bin/hello' '/bin/hello' 'outfile'" \
					"./pipex 'infile' '/bin/echo hello world' '/bin/cat' outfile" \
					"./pipex 'testsegv.c' 'cat' 'grep str\ =\ NULL' 'outfile'" \
					"./pipex 'infile2' 'cat' 'awk -F \";\" \"{print \$1}\"' 'outfile'" \
					"./pipex 'infile2' '\"l\"\"s\"' '\"l\"\"s\"\"\" \"\"\"\"\"-\"\"l\"\"a\"' 'outfile'" \
					"./pipex 'infile2' '\a\b\c' '\"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\"' 'outfile'" \
					"./pipex 'infile2' '\a\b\c\' '\"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\"' 'outfile'")

bashInstructions=("< '' '' | '' > ''" \
				"< '' cat | cat > ''" \
				"< infile cat | cat > ''" \
				"< '' cat | cat > outfile" \
				"< infile '' | '' > outfile" \
				"< infile cat | cat > outfile" \
				"< infile ./testsegv | ./testsegv > outfile" \
				"< infile ./myfolder | cat > outfile" \
				"< infile cat | ./myfolder > outfile" \
				"< infile /bin/hello | /bin/hello > outfile" \
				"< infile /bin/echo hello world | /bin/cat > outfile" \
				"< testsegv.c cat | grep str\ =\ NULL > outfile" \
				"< infile2 cat | awk -F \";\" '{print \$1}' > outfile" \
				"< infile2 \"l\"\"s\" | \"l\"\"s\"\"\" \"\"\"\"\"-\"\"l\"\"a\" > outfile" \
				"< infile2 \a\b\c | \"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\" > outfile" \
				"< infile2 \a\b\c | \"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\" > outfile")

echo -e "${yellow}Testing Makefile rules:${nocolor}";
echo "";
mkdir myfolder;
make > /dev/null
if [ $? -ne 0 ]; then
	echo -e "${red}Error compiling the Makefile with the rule make all${nocolor}";
	exit 1;
fi
if [ ! -f "pipex" ]; then
	echo -e "${red}pipex executable not found.${nocolor}"
	exit 1;
fi
make clean > /dev/null
if [ $? -ne 0 ]; then
	echo -e "${red}Error executing the rule make clean${nocolor}";
	exit 1;
fi
make fclean > /dev/null
if [ $? -ne 0 ]; then
	echo -e "${red}Error executing the rule make fclean${nocolor}";
	exit 1;
fi
make re > /dev/null
if [ $? -ne 0 ]; then
	echo -e "${red}Error executing the rule make re${nocolor}";
	exit 1;
fi
if [ ! -f "pipex" ]; then
	echo -e "${red}pipex executable not found.${nocolor}"
	exit 1;
fi
echo -e "${green}Good!! All the rules seems to work properly${nocolor}";
echo "";
sleep 2
echo -e "${yellow}Creating files for testing.${nocolor}"
if [ ! -d "testValgrind" ]; then
	mkdir testValgrind;
else
	cd testValgrind;
	rm *;
	cd ..;
fi
echo "THIS IS AN INFILE" > infile
echo -e "hello;world\nhola;mundo" > infile2

cc -Wall -Wextra -Werror testsegv.c -o testsegv;

returnPipex=0
returnBash=0
index=0
sizeArray=${#pipexInstructions[@]}
echo "";
echo -e "${yellow}PERMORMING TESTS. CHECK THE FOLDER testValgrind TO SEE THE RESULTS${nocolor}";
echo ""
while [ $index -lt $sizeArray ]; do
	echo -e "${yellow}Performing test number $(expr $index + 1).${nocolor}";
	echo "";
	{
		echo "TEST NUMBER $(expr $index + 1): ${pipexInstructions[$index]} and ${bashInstructions[$index]}";
		echo "";
		echo "BASH:";
		eval "${bashInstructions[$index]}";
		returnBash=$?;
		if [ -f "outfile" ]; then
			echo "";
			echo "Content of outfile from bash:";
			cat outfile;
			rm -f outfile;
		fi
		echo "";
		echo "PIPEX:";
		eval "${pipexInstructions[$index]}";
		returnPipex=$?
		if [ -f "outfile" ]; then
			echo "";
			echo "Content of outfile from pipex:";
			cat outfile;
			rm -f outfile;
		fi
		echo "";
		echo "Return value of bash: ${returnBash}. Return value of pipex: ${returnPipex}";
		echo -n "Result of return: ";
		if [ $returnBash -ne $returnPipex ]; then
			echo -e "${red}KO.${yellow} A difference in the return value doesn't mean that the project should be failed${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
	} 2>&1 | tee test"$(expr $index + 1)".txt;
	{
		echo "";
		echo "Testing leaks with valgrind";
		echo "";
		echo "";
		eval "valgrind --leak-check=full --show-leak-kinds=all --undef-value-errors=no --error-exitcode=200 --track-fds=yes ${pipexInstructions[$index]}";
		valgrindReturn="$?";
	} &>> test"$(expr $index + 1)".txt;
	{
		echo -ne "${yellow}Checking leaks: ${nocolor}";
		if [ $valgrindReturn -ne $valgrindConst ]; then
			echo -e "${green}OK.${nocolor}";
			echo "";
		else
			echo -e "${red}KO.${nocolor}";
			echo "";
		fi
	} 2>&1 | tee -a test"$(expr $index + 1)".txt
	mv test"$(expr $index + 1)".txt testValgrind/
	echo -e "${yellow}Done. If you want to check memory leaks and memory issues, check the file test$(expr $index + 1).txt inside the folder testValgrind to see the results.${nocolor}"
	((index++));
	echo "";
	echo "";
	sleep 2;
done
bash unsetting_bash.sh;
echo -e "${green}Test for mandatory part done!!${nocolor}"
make fclean > /dev/null
exit 0;