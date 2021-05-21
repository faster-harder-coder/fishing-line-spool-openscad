#!/bin/bash
RESULT=0
ORIGINALIFS="$IFS"
IFS=$'\n'

if git rev-parse --verify HEAD >/dev/null 2>&1
then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	against=$(git hash-object -t tree /dev/null)
fi

FILELIST=$(git diff --cached --name-only --diff-filter=d | grep -e '.scad$')
for FILE in ${FILELIST}; do
    $(git show :${FILE} | grep -q '[[:blank:]]$' -- >/dev/null 2>&1)
    if [ "$?" -ne "1" ]; then
        echo "pre-commit: Found trailing spaces in $FILE"
        RESULT=1
        # Fix file, but don't add it as this might be a partial commit
        sed -i 's/[[:space:]]*$//' "$FILE"
        continue
    fi
done

if [ "$RESULT" -ne "0" ]; then
	echo "Errors in files found, please git add them and commit again."
fi

IFS="$ORIGINALIFS"
exit $RESULT
