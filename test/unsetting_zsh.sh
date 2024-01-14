#!/bin/zsh

unset PATH;
{
	echo "TEST NUMBER 20 : ./pipex infile2 ls \"wc -l\" outfile and < infile2 ls | wc -l > outfile when PATH is not setted";
	echo "";
	echo "";
	echo "ZSH:";
	< infile2 ls | wc -l > outfile
	returnZsh=$?;
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
	echo "Return value of zsh: " ${returnZsh} ". Return value of pipex: " ${returnPipex};
	echo "";
	echo "";
	echo "Testing leaks with valgrind: This will be stored in the in test20.txt";
	echo "";
	echo "";
	/usr/bin/valgrind --leak-check=full --show-reachable=yes --track-origins=yes --verbose --tool=memcheck --trace-children=yes --track-fds=yes ./pipex infile2 ls "wc -l" outfile;
} &> testValgrind/test20.txt
{
	echo "TEST NUMBER 21 : ./pipex infile2 /bin/ls \"/usr/bin/wc -l\" outfile and < infile2 /bin/ls | /usr/bin/wc -l > outfile when PATH is not setted";
	echo "";
	echo "";
	echo "ZSH:";
	< infile2 /bin/ls | /usr/bin/wc -l > outfile
	returnZsh=$?;
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
	echo "Return value of zsh: " ${returnZsh} ". Return value of pipex: " ${returnPipex};
	echo "";
	echo "";
	echo "Testing leaks with valgrind: This will be stored in the in test21.txt";
	echo "";
	echo "";
	/usr/bin/valgrind --leak-check=full --show-reachable=yes --track-origins=yes --verbose --tool=memcheck --trace-children=yes --track-fds=yes ./pipex infile2 /bin/ls "/usr/bin/wc -l" outfile;
} &> testValgrind/test21.txt