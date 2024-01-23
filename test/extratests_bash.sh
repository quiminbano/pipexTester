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

unset PATH;
{
	echo -e "${yellow}Performing test number 22.${nocolor}";
	echo "";
	{
		echo "TEST NUMBER 22 : ./pipex infile2 ls \"wc -l\" outfile2 and < infile2 ls | wc -l > outfile when PATH is not setted";
		echo "";
		echo "";
		echo "BASH:";
		/bin/touch outfile;
		/bin/touch outfile2;
		< infile2 ls | wc -l > outfile
		returnShell=$?;
		if [ -f "outfile" ]; then
		echo ""
		echo "Content of outfile from bash:"
		/bin/cat outfile
		fi
		echo "";
		echo "PIPEX:";
		./pipex infile2 ls "wc -l" outfile2;
		returnPipex=$?
		if [ -f "outfile2" ]; then
			echo ""
			echo "Content of outfile2 from pipex:"
			/bin/cat outfile2
		fi
		echo "";
		echo -ne "${yellow}Checking the contents of output files generated by shell and pipex: ";
		/usr/bin/diff outfile outfile2;
		if [ $? -ne 0 ]; then
			echo -e "${red}KO. The output, produced by your pipex, differs with the output produced by shell.${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
		echo "Return value of bash: ${returnShell}. Return value of pipex: ${returnPipex}";
		if [ $returnShell -ne $returnPipex ]; then
			echo -e "${red}KO.${yellow} A difference in the return value doesn't mean that the project should be failed${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
	} 2>&1 | /usr/bin/tee testValgrind/test22.txt;
	{
		echo "";
		echo "Testing leaks with valgrind: This will be stored in the in test20.txt";
		echo "";
		echo "";
		/usr/bin/valgrind --leak-check=full --show-leak-kinds=all --undef-value-errors=no --error-exitcode=200 --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
		valgrindReturn=$?;
	}  &>> testValgrind/test22.txt
	{
		echo -ne "${yellow}Checking leaks and memory errors: ${nocolor}";
		if [ $valgrindReturn -ne $valgrindConst ]; then
			echo -e "${green}OK.${nocolor}";
			echo "";
		else
			echo -e "${red}KO.${nocolor}";
			echo "";
		fi
	} 2>&1 | /usr/bin/tee -a testValgrind/test22.txt
	echo -e "${yellow}Done. If you want to check memory leaks and memory issues, check the file test20.txt inside the folder testValgrind to see the results.${nocolor}"
	echo "";
	echo "";
	/bin/rm -f outfile;
	/bin/rm -f outfile2;
}
echo -e "${brightnocolor}Do you want to continue to the next test? Press y to continue, press n to finish. (y/n).${nocolor}";
while true;
do
	echo "";
	echo -e "${pink}Next test: ./pipex infile2 /bin/ls \"/usr/bin/wc -l\" outfile when PATH is not setted${nocolor}";
	echo -e "${pink}           < infile2 /bin/ls | /usr/bin/wc -l > when PATH is not setted${nocolor}";
	echo "";
	read condition;
	readStatus=$?;
	condition=$(echo "$condition" | /usr/bin/tr '[:upper:]' '[:lower:]');
	if [ "${condition}" == "y" ]; then
		break
	elif [ "${condition}" == "n" ] || [ $readStatus -ne 0 ]; then
		echo -e "${green}Test for mandatory part done!!${nocolor}"
		exit 0;
	else
		echo -e "${brightred}Option not valid. Try again please.${nocolor}";
		echo "";
	fi	
done
{
	echo -e "${yellow}Performing test number 21.${nocolor}";
	echo "";
	{
		echo "TEST NUMBER 23 : ./pipex infile2 /bin/ls \"/usr/bin/wc -l\" outfile2 and < infile2 /bin/ls | /usr/bin/wc -l > outfile when PATH is not setted";
		echo "";
		echo "";
		echo "BASH:";
		/bin/touch outfile;
		/bin/touch outfile2;
		< infile2 /bin/ls | /usr/bin/wc -l > outfile
		returnShell=$?;
		if [ -f "outfile" ]; then
		echo ""
		echo "Content of outfile from bash:"
		/bin/cat outfile
		fi
		echo "";
		echo "PIPEX:";
		./pipex infile2 /bin/ls "/usr/bin/wc -l" outfile2;
		returnPipex=$?
		if [ -f "outfile2" ]; then
			echo ""
			echo "Content of outfile from pipex:"
			/bin/cat outfile2
		fi
		echo "";
		echo -ne "${yellow}Checking the contents of output files generated by shell and pipex: ";
		/usr/bin/diff outfile outfile2;
		if [ $? -ne 0 ]; then
			echo -e "${red}KO. The output, produced by your pipex, differs with the output produced by shell.${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
		echo "Return value of bash: ${returnShell}. Return value of pipex: ${returnPipex}";
		if [ $returnShell -ne $returnPipex ]; then
			echo -e "${red}KO.${yellow} A difference in the return value doesn't mean that the project should be failed${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
	} 2>&1 | /usr/bin/tee testValgrind/test23.txt;
	{
		echo "";
		echo "Testing leaks with valgrind: This will be stored in the in test23.txt";
		echo "";
		echo "";
		/usr/bin/valgrind --leak-check=full --show-leak-kinds=all --undef-value-errors=no --error-exitcode=200 --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
		valgrindReturn=$?;
	}  &>> testValgrind/test23.txt
	{
		echo -ne "${yellow}Checking leaks: ${nocolor}";
		if [ $valgrindReturn -ne $valgrindConst ]; then
			echo -e "${green}OK.${nocolor}";
			echo "";
		else
			echo -e "${red}KO.${nocolor}";
			echo "";
		fi
	} 2>&1 | /usr/bin/tee -a testValgrind/test23.txt
	echo -e "${yellow}Done. If you want to check memory leaks and memory issues, check the file test18.txt inside the folder testValgrind to see the results.${nocolor}"
	echo "";
	echo "";
	/bin/sleep 2;
}