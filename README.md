# PipexTester

This unit tester was made to test the project called [pipex](https://github.com/quiminbano/pipex-version-2024). A project from the common core of 42 Network.

### Disclaimer

This unit tester requires an installation of docker, docker-compose or docker desktop. Make sure you have them installed.

If you are trying to run docker in a school computer from 42 network, you can install docker from the software center that the school provides for you. Then, you can run init_docker.sh, provided in [42 toolbox](https://github.com/alexandregv/42toolbox). This script should set up for you all the dependencies to run docker.

### How to install the tester.

Clone this repository inside your pipex folder:

```bash
https://github.com/quiminbano/pipexTester
```

### How to run the tester.

Go into the folder you previously cloned, then execute the following command:

```bash
bash start.sh
```
### Recomendations to avoid compilation errors of your pipex in the tester.

If you have made your pipex project in macOS and you uses limit macros, for example `SIZE_MAX`, it is recommended to include the header `<stdint.h>` where it is required.

In the Makefile, to generate the pipex program, you should include the dependencies of your libft.a file AFTER the object files are mentioned

For example:
```bash
$(CC) $(FLAGS) -I. -Ilibft $(OBJ) $(OBJ_PAR) $(LIBFT) -o $(NAME)
```
where
```bash
LIBFT = -Llibft -lft
```
