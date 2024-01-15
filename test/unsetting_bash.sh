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
	echo -e "${yellow}Performing test number 17.${nocolor}";
	echo "";
	{
		echo "TEST NUMBER 17 : ./pipex infile2 ls \"wc -l\" outfile and < infile2 ls | wc -l > outfile when PATH is not setted";
		echo "";
		echo "";
		echo "BASH:";
		< infile2 ls | wc -l > outfile
		returnBash=$?;
		if [ -f "outfile" ]; then
		echo ""
		echo "Content of outfile from zsh:"
		/bin/cat outfile
		/bin/rm -f outfile;
		fi
		echo "";
		echo "PIPEX:";
		./pipex infile2 ls "wc -l" outfile;
		returnPipex=$?
		if [ -f "outfile" ]; then
			echo ""
			echo "Content of outfile from pipex:"
			/bin/cat outfile
			/bin/rm -f outfile
		fi
		echo "";
		echo "Return value of bash: ${returnBash}. Return value of pipex: ${returnPipex}";
		if [ $returnBash -ne $returnPipex ]; then
			echo -e "${red}KO.${yellow} A difference in the return value doesn't mean that the project should be failed${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
	} 2>&1 | /usr/bin/tee testValgrind/test17.txt;
	{
		echo "";
		echo "Testing leaks with valgrind: This will be stored in the in test17.txt";
		echo "";
		echo "";
		/usr/bin/valgrind --leak-check=full --show-leak-kinds=all --undef-value-errors=no --error-exitcode=200 --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
	}  &>> testValgrind/test17.txt
	{
		echo -ne "${yellow}Checking leaks: ${nocolor}";
		if [ $valgrindReturn -eq 200 ]; then
			echo -e "${red}KO.${nocolor}";
			echo "";
		else
			echo -e "${green}OK.${nocolor}";
			echo "";
		fi
	} 2>&1 | /usr/bin/tee -a testValgrind/test17.txt
	echo -e "${yellow}Done. If you want to check memory leaks and memory issues, check the file test17.txt inside the folder testValgrind to see the results.${nocolor}"
	echo "";
	echo "";
	/bin/sleep 2;
}
{
	echo -e "${yellow}Performing test number 18.${nocolor}";
	echo "";
	{
		echo "TEST NUMBER 18 : ./pipex infile2 /bin/ls \"/usr/bin/wc -l\" outfile and < infile2 /bin/ls | /usr/bin/wc -l > outfile when PATH is not setted";
		echo "";
		echo "";
		echo "BASH:";
		< infile2 /bin/ls | /usr/bin/wc -l > outfile
		returnBash=$?;
		if [ -f "outfile" ]; then
		echo ""
		echo "Content of outfile from zsh:"
		/bin/cat outfile
		/bin/rm -f outfile;
		fi
		echo "";
		echo "PIPEX:";
		./pipex infile2 /bin/ls "/usr/bin/wc -l" outfile;
		returnPipex=$?
		if [ -f "outfile" ]; then
			echo ""
			echo "Content of outfile from pipex:"
			/bin/cat outfile
			/bin/rm -f outfile
		fi
		echo "";
		echo "Return value of bash: ${returnBash}. Return value of pipex: ${returnPipex}";
		if [ $returnBash -ne $returnPipex ]; then
			echo -e "${red}KO.${yellow} A difference in the return value doesn't mean that the project should be failed${nocolor}";
		else
			echo -e "${green}OK.${nocolor}";
		fi
		echo "";
	} 2>&1 | /usr/bin/tee testValgrind/test18.txt;
	{
		echo "";
		echo "Testing leaks with valgrind: This will be stored in the in test18.txt";
		echo "";
		echo "";
		/usr/bin/valgrind --leak-check=full --show-leak-kinds=all --undef-value-errors=no --error-exitcode=200 --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
	}  &>> testValgrind/test18.txt
	{
		echo -ne "${yellow}Checking leaks: ${nocolor}";
		if [ $valgrindReturn -eq $valgrindConst ]; then
			echo -e "${red}KO.${nocolor}";
			echo "";
		else
			echo -e "${green}OK.${nocolor}";
			echo "";
		fi
	} 2>&1 | /usr/bin/tee -a testValgrind/test18.txt
	echo -e "${yellow}Done. If you want to check memory leaks and memory issues, check the file test18.txt inside the folder testValgrind to see the results.${nocolor}"
	echo "";
	echo "";
	/bin/sleep 2;
}