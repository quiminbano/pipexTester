#!/usr/local/bin/bash

if [ "${TEST}" == "mandatory" ]; then
	/usr/local/bin/bash mandatory.sh;
fi
if [ "${TEST}" == "bonus" ]; then
	/usr/local/bin/bash bonus.sh;
fi
if [ "${TEST}" == "all" ]; then
	/usr/local/bin/bash mandatory.sh;
	/usr/local/bin/bash bonus.sh;
fi