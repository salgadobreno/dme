#!/bin/bash
# Created July 4th. - Edson Lek Hong Ma
#

grep -rni --exclude-dir={node_modules,public,.git}  '[//|#]*todo' .
