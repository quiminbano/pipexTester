#!/usr/local/bin/bash

red='\033[0;31m'
brightred='\033[1;31m'
green='\033[0;32m'
brightgreen='\033[1;32m'
yellow='\033[0;33m'
brightyellow='\033[1;33m'
pink='\033[38;5;161m'
nocolor='\033[0m'
brightnocolor='\033[1m'

valgrindConst=200;
options=("y" "n")
pipexInstructions=("./pipex '' '' '' ''" \
					"./pipex '' 'cat' 'cat' ''" \
					"./pipex 'infile' 'cat' 'cat' ''" \
					"./pipex '' 'cat' 'cat' 'outfile2'" \
					"./pipex 'infile' '' '' 'outfile2'" \
					"./pipex 'infile' 'cat' 'cat' 'outfile2'" \
					"./pipex 'infile' '/bin/hello' '/bin/hello' 'outfile2'" \
					"./pipex 'infile' '/bin/echo hello world' '/bin/cat' outfile2" \
					"./pipex 'infile' 'sleep 5' 'echo hello world' 'outfile2'" \
					"./pipex 'infile' './testsegv' './testsegv' 'outfile2'" \
					"./pipex 'infile' './myfolder' 'cat' 'outfile2'" \
					"./pipex 'infile' 'cat' './myfolder' 'outfile2'" \
					"./pipex 'testsegv.c' 'cat' 'grep str\ =\ NULL' 'outfile2'" \
					"./pipex 'infile2' 'cat' 'awk -F \";\" \"{print \$1}\"' 'outfile2'" \
					"./pipex 'infile2' '\"l\"\"s\"' '\"i\"\"p\"\"\" \"\"\"\"\"-\"\"\"\"s\" \"\"\"l\"\"i\"\"nk\"' 'outfile2'" \
					"./pipex 'infile2' '\a\b\c' '\"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\"' 'outfile2'" \
					"./pipex 'infile2' '\a\b\c\' '\"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\"' 'outfile2'")

shellInstructions=("< '' '' | '' > ''" \
				"< '' cat | cat > ''" \
				"< infile cat | cat > ''" \
				"< '' cat | cat > outfile" \
				"< infile '' | '' > outfile" \
				"< infile cat | cat > outfile" \
				"< infile /bin/hello | /bin/hello > outfile" \
				"< infile /bin/echo hello world | /bin/cat > outfile" \
				"< infile sleep 5 | echo hello world > outfile" \
				"< infile ./testsegv | ./testsegv > outfile" \
				"< infile ./myfolder | cat > outfile" \
				"< infile cat | ./myfolder > outfile" \
				"< testsegv.c cat | grep str\ =\ NULL > outfile" \
				"< infile2 cat | awk -F \";\" '{print \$1}' > outfile" \
				"< infile2 \"l\"\"s\" | \"i\"\"p\"\"\" \"\"\"\"\"-\"\"\"\"s\" \"\"\"l\"\"i\"\"nk\" > outfile" \
				"< infile2 \a\b\c | \"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\" > outfile" \
				"< infile2 \a\b\c | \"l\"\"s\"\"\"\ \"\"\"\"\"-\"\"l\"\"a\" > outfile")
echo "";
echo -ne "${yellow}Checking norminette:${nocolor} ";
norminette &> /dev/null;
if [ $? -ne 0 ]; then
	echo -e "${red}KO.${nocolor}";
else
	echo -e "${green}OK.${nocolor}";
fi
echo "";
echo -e "${yellow}Testing Makefile rules:${nocolor}";
echo "";
if [ ! -d "myfolder" ]; then
	mkdir myfolder;
fi
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
if [ ! -f "pipex" ]; then
	echo -e "${red}pipex executable not found after using make clean.${nocolor}"
	exit 1;
fi
make fclean > /dev/null
if [ $? -ne 0 ]; then
	echo -e "${red}Error executing the rule make fclean${nocolor}";
	exit 1;
fi
if [ -f "pipex" ]; then
	echo -e "${red}pipex executable found after using make fclean.${nocolor}"
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
fi
if [ ! -f "infile" ]; then
	echo "THIS IS AN INFILE" > infile;
fi
if [ ! -f "outfile" ]; then
	echo -e "hello;world\nhola;mundo" > infile2;
fi
cc -Wall -Wextra -Werror testsegv.c -o testsegv;

returnPipex=0
returnShell=0
index=0
sizeArray=${#pipexInstructions[@]}
echo "";
echo -e "${yellow}PERMORMING TESTS. CHECK THE FOLDER testValgrind TO SEE THE RESULTS${nocolor}";
echo ""
flag=0;
while [ $index -lt $sizeArray ]; do
	select opt in "${options[@]}";
	do
		echo -e "${brightyellow}Between the tests 10 and 17, it is not necessary, in my opinion, to handle these cases exactly as your shell of preference does.\n \
		However, these tests should never crash your pipex.\n \
		Press y to continue to these tests or press n to skip these tests and go to test 18 or press q to quit (y/n/q)${nocolor}";
		read condition1;
		case $(echo "${condition1}" | tr '[:upper:]' '[:lower:]') in
		"y")
			flag=1;
			break
			;;
		"n")
			flag=2;
			break
			;;
		"q")
			echo -e "${green}Test for mandatory part done!!${nocolor}";
			exit 0;
			;;
		*)
			echo -e "${brightred}Option not valid. Try again please.${nocolor}";
			echo "";
			;;
		esac
	done
	if [ $flag -eq 2 ]; then
		break
	fi
	echo -e "${yellow}Performing test number $(expr $index + 1).${nocolor}";
	echo "";
	{
		echo "TEST NUMBER $(expr $index + 1): ${pipexInstructions[$index]} and ${shellInstructions[$index]}";
		echo "";
		echo "BASH:";
		eval "${shellInstructions[$index]}";
		returnShell=$?;
		eval "${shellInstructions[$index]}" &> temp;
		cat temp | awk -F ":" '{print $(NF-1), $NF}' > shell_output;
		rm temp;
		if [ -f "outfile" ]; then
			echo "";
			echo "Content of outfile from bash:";
			cat outfile;
		fi
		echo "";
		echo "PIPEX:";
		if [ $index -ne 8 ]; then
			eval "${pipexInstructions[$index]}";
		else
			eval "${pipexInstructions[$index]} &";
		fi
		if [ $index -eq 3 ] || [ $index -eq 8 ]; then
			echo -ne "${yellow}Checking the existance of a output file: ${nocolor}";
			sleep 1;
			if [ ! -f "outfile2" ]; then
				echo -e "${red}KO.${nocolor}";
				echo "";
			else
				echo -e "${green}OK.${nocolor}";
				echo "";
			fi
		fi
		if [ $index -eq 8 ]; then
			echo -ne "${yellow}Checking the contents of output files generated by shell and pipex: ${nocolor}";
			diff outfile outfile2;
			if [ $? -ne 0 ]; then
				echo -e "${red}KO.${nocolor}";
				echo "";
			else
				echo -e "${green}OK.${nocolor}";
				echo "";
			fi
			sleep 4;
		fi
		before=$(date +%s);
		eval "${pipexInstructions[$index]}" &> temp;
		returnPipex=$?
		after=$(date +%s);
		if [ $index -eq 8 ]; then
			echo -ne "${yellow}Checking the execution time of pipex in test 9: ${nocolor}";
			diffTime=$((after - before));
			if [ $diffTime -lt 1 ] || [ $diffTime -gt 16 ]; then
				echo -e "${red}KO.${nocolor}";
			else
				echo -e "${green}OK.${nocolor}";
			fi
		fi
		cat temp | awk -F ":" '{print $(NF-1), $NF}' > pipex_output;
		if [ -f "outfile2" ]; then
			echo "";
			echo "Content of outfile from pipex:";
			cat outfile2;
		fi
		echo "";
		if [ $index -gt 3 ] && [ $index -ne 8 ]; then
			echo -ne "${yellow}Checking the contents of output files generated by shell and pipex: ";
			diff outfile outfile2;
			if [ $? -ne 0 ]; then
				echo -e "${red}KO.${nocolor}";
			else
				echo -e "${green}OK.${nocolor}";
			fi
		fi
		echo "";
		echo "Return value of bash: ${returnShell}. Return value of pipex: ${returnPipex}";
		echo -n "Result of return: ";
		if [ $returnShell -ne $returnPipex ]; then
			echo -e "${red}KO.${yellow} A difference in the return value doesn't mean that the project should be failed${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
		if [ $index -ne 9 ]; then
			echo -ne "${yellow}Checking error output: ${nocolor}";
			diff shell_output pipex_output;
			if [ $? -eq 1 ]; then
				echo -e "${red}KO.${nocolor}";
			else
				echo -e "${green}OK.${nocolor}";
			fi
		else
			echo -e "${yellow}Test 10: There're some differences in the output gotten in a script execution and executing the command in the shell. Dropping this analysis${nocolor}";
		fi
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
	echo -e "${yellow}Done. If you want to check the output given by valgrind, check the file test$(expr $index + 1).txt inside the folder testValgrind to see the results.${nocolor}"
	((index++));
	echo "";
	echo "";
	rm -f outfile;
	rm -f outfile2;
	select opt2 in "${options[@]}"
	do
		echo -e "${brightnocolor}Do you want to continue to the next test? Press y to continue, press n to finish. (y/n).${nocolor}";
		case $(echo "$opt" | tr '[:upper:]' '[:lower:]') in
		"y")
			break
			;;
		"n")
			echo -e "${green}Test for mandatory part done!!${nocolor}"
			exit 0;
			;;
		*)
			echo -e "${brightred}Option not valid. Try again please.${nocolor}";
			echo "";
		esac
	done
	echo "";
done

bash unsetting_bash.sh;
echo -e "${green}Test for mandatory part done!!${nocolor}"
make fclean > /dev/null
exit 0;