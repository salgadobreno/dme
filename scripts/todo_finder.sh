#!/bin/bash
# Created July 4th. - Edson Lek Hong Ma
#

grep --colour=always -rni --exclude-dir={node_modules,public,.git} --exclude={"todo.txt","Rakefile","todo_finder.sh","yarn.lock"}  '[//|#]*todo' . |
sed -re  's/^([^:]+):(\x1b\[m\x1b\[K)[[:space:]]*(.*)/\1\x01\2\3/' |
sed -re  's/^([^#]+):(\x1b\[m\x1b\[K)[[:space:]]*(.*)/\1\x01\2\3/' |
column -s $'\x01' -t
