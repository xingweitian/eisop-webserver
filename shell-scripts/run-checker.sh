#!/bin/sh

# $1 is a string representing a JSON object that the Java backend
# expects as input, such as: java_jail/cp/traceprinter/test-input.txt

# tricky! use a heredoc to pipe the $1 argument into the stdin of the
# java executable WITHOUT interpreting escape chars such as '\n' ...
# echo doesn't work here since it interprets '\n' and other chars
#
# TODO: use -Xmx512m if we need more memory

# first change to script directory so relative path works again
cd $(dirname "$0")

if [ "$(uname)" = "Darwin" ] ; then
  JAVA_HOME=${JAVA_HOME:-$(/usr/libexec/java_home)}
else
  JAVA_HOME=${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")}
fi

# CF=$(cd ../enabled-checker-framework && pwd)
CF=$2
IS_RISE4FUN=$3

cat <<ENDEND | $JAVA_HOME/bin/java -Xmx2500M -ea -ea:com.sun.tools... --add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED --add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED --add-opens jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED -cp $CF/checker/dist/checker.jar:$CF/checker/dist/javac.jar:../CheckerPrinter/bin:../CheckerPrinter/javax.json-1.0.jar checkerprinter.InMemory $CF $IS_RISE4FUN
$1
ENDEND
