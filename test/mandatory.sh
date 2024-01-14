#!/usr/local/bin/bash

red='\033[0;31m'
brightred='\033[1;31m'
green='\033[0;32m'
brightgreen='\033[1;32m'
yellow='\033[0;33m'
brightyellow='\033[1;33m'
pink='\033[38;5;161m'
nocolor='\033[0m'

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
make > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo -e "${red}Error compiling the Makefile with the rule make all${nocolor}";
	exit 1;
fi
if [ ! -f "pipex" ]; then
	echo -e "${red}pipex executable not found.${nocolor}"
	exit 1;
fi
make clean > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo -e "${red}Error executing the rule make clean${nocolor}";
	exit 1;
fi
make fclean > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo -e "${red}Error executing the rule make fclean${nocolor}";
	exit 1;
fi
make re > /dev/null 2>&1
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
fi
echo "THIS IS AN INFILE" > infile
echo -e "hello;world\nhola;mundo" > infile2

cc -Wall -Wextra -Werror testsegv.c -o testsegv;

returnPipex=0
returnBash=0
index=1
sizeArray=${#pipexInstructions[@]}
echo "";
echo -e "${yellow}PERMORMING TESTS. CHECK THE FOLDER testValgrind TO SEE THE RESULTS${nocolor}";
echo ""
while [ $index -le $sizeArray ]; do
	echo -e "${yellow}Performing test number ${index}. Differences between the return value shouldn't be a reason to fail the project${nocolor}"
	{
		echo "";
		echo "";
		echo "TEST NUMBER ${index}: ${pipexInstructions[$index]} and ${bashInstructions[$index]}";
		echo "BASH:";
		eval "${bashInstructions[$index]}";
		returnBash=$?;
		if [ -f "outfile" ]; then
			echo ""
			echo "Content of outfile from bash:"
			cat outfile
			rm -f outfile;
		fi
		echo "";
		echo "PIPEX:";
		eval "${pipexInstructions[$index]}";
		returnPipex=$?
		if [ -f "outfile" ]; then
			echo ""
			echo "Content of outfile from pipex:"
			cat outfile
			rm -f outfile
		fi
		echo "";
		echo "Return value of bash:${returnBash}. Return value of pipex:${returnPipex}";
		echo "";
		echo "";
		echo "Testing leaks with valgrind";
		echo "";
		echo "";
		eval "valgrind --leak-check=full --show-reachable=yes --track-origins=yes --verbose --tool=memcheck --trace-children=yes --track-fds=yes ${pipexInstructions[$index]}";
	} &> test${index}.txt;
	mv test${index}.txt testValgrind/
	echo -e "${yellow}Done. Check the file test${index}.txt inside the folder testValgrind to see the results.${nocolor}"
	((index++));
	echo "";
	echo "";
	sleep 2;
done
{
	echo ""
	echo ""
	echo "TEST NUMBER 17 : ./pipex infile2 ls \"wc -l\" outfile when fork() fails";
	cc -fPIC -shared mock_fork.c -o libmockfork.so
	LD_PRELOAD=/pipex/libmockfork.so ./pipex infile2 ls "wc -l" outfile
	echo ""
	echo ""
	echo "Testing leaks with valgrind: This will be stored in the in test17.txt";
	echo ""
	echo ""
	LD_PRELOAD=/pipex/libmockfork.so valgrind --leak-check=full --show-reachable=yes --track-origins=yes --verbose --tool=memcheck --trace-children=yes --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
	cat outfile
} &> test17.txt;
mv test17.txt testValgrind/
{
	echo ""
	echo ""
	echo "TEST NUMBER 18 : ./pipex infile2 ls \"wc -l\" outfile when pipe() fails";
	cc -fPIC -shared mock_pipe.c -o libmockpipe.so
	LD_PRELOAD=/pipex/libmockpipe.so ./pipex infile2 ls "wc -l" outfile
	echo ""
	echo "Testing leaks with valgrind: This will be stored in the in test18.txt";
	LD_PRELOAD=/pipex/libmockpipe.so valgrind --leak-check=full --show-reachable=yes --track-origins=yes --verbose --tool=memcheck --trace-children=yes --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
	cat outfile;
} &> test18.txt;
mv test18.txt testValgrind/;
bash unsetting.sh;
echo -e "${green}Test for mandatory part done!!${nocolor}"
make fclean > /dev/null 2>&1
exit 0;