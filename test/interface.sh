#!/usr/local/bin/bash

if [ "${TEST}" == "mandatory" ] && [ "${TYPE_SHELL}" == "bash" ]; then
	/usr/local/bin/bash mandatory_bash.sh;
fi
if [ "${TEST}" == "mandatory" ] && [ "${TYPE_SHELL}" == "zsh" ]; then
	/bin/zsh mandatory_zsh.sh;
fi
if [ "${TEST}" == "bonus" ] && [ "${TYPE_SHELL}" == "bash" ]; then
	/usr/local/bin/bash bonus_bash.sh;
fi
if [ "${TEST}" == "bonus" ] && [ "${TYPE_SHELL}" == "zsh" ]; then
	/bin/zsh bonus_zsh.sh;
fi
if [ "${TEST}" == "all" ] && [ "${TYPE_SHELL}" == "bash" ]; then
	/usr/local/bin/bash mandatory_bash.sh;
	/usr/local/bin/bash bonus_bash.sh;
fi
if [ "${TEST}" == "all" ] && [ "${TYPE_SHELL}" == "zsh" ]; then
	/bin/zsh mandatory_zsh.sh;
	/bin/zsh bonus_zsh.sh;
fi