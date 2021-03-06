#!/bin/bash
# Created July 4th. - Edson Lek Hong Ma
#

grep --colour=always -rniI --exclude-dir={node_modules,public,.git,scripts} --exclude={"todo.txt","Rakefile","yarn.lock","README.md"}  '[//|#]*todo' . |
sed -re  's/^([^:]+):(\x1b\[m\x1b\[K)[[:space:]]*(.*)/\1\x01\2\3/' |
sed -re  's/^([^#]+):(\x1b\[m\x1b\[K)[[:space:]]*(.*)/\1\x01\2\3/' |
column -s $'\x01' -t
