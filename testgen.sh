#!/bin/bash

# functions
log() {
  for param in $@
  do
    echo "LOG: $param"
  done
}

# confirming override
while [ $# -gt 0 ]
do
  arg=$1
  case $arg in
    -o)
      while [ -z $answer ]
      do
        read -p 'Override all existiong tests (y/n)' -n 2 answer
        echo -e "\r"
        
        if [ -z $answer ]; then
          answer=""
        elif [ $answer = 'y' ]; then
          override=true;
        elif [ $answer = 'n' ]; then
          override=false
        else
          answer=""
        fi
      done
      shift
      ;;
    *)
      dir=$arg
      shift
      ;;
  esac
done

# check if argument is ok, ask again if not
while [ -z $dir ] || [ -z $dir ]; do
  read -p 'enter valide path: ' dir
done

# setting needed variables
path=`realpath $dir`
testDirPath=`echo $path | sed -e 's#src/main/java#src/test/java#'`
package=`echo $path | awk -F'/main/java/' '{print $2}' | sed -e 's#/#.#g'`

# create test dir if not existing
if [ ! -e $testDirPath ]; then
  mkdir -p $testDirPath
fi

log "working dir: $dir" "realpath: $path" "testDirPath: $testDirPath"
log "package: $package"

for file in `ls $dir`; do 
  class=`echo $file | awk -F'.' '{print $1}'`
  extension=`echo $file | awk -F'.' '{print $2}'`

  if [ ! -z $extension ] && [ 'java' == $extension ]; then
    testFilePath=${testDirPath}/${file}
    if [ ! -e $testFilePath ] || [ $override = true ]; then
      echo "package $package" > $testFilePath
      echo "" >> $testFilePath
      echo "public class $class {" >> $testFilePath
      echo "  @Test" >> $testFilePath
      echo "  public void methodToTest() {}" >> $testFilePath
      echo "}" >> $testFilePath
      log "SUCCESS file written: $testFilePath"
    fi
  fi

  extension=""

done