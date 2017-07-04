#!/bin/bash
# Created July 4th. - Edson Lek Hong Ma
#

grep -rni --exclude-dir={*node_modules*,*app/web/public*,*.git*}  '[//|#]*todo' .
