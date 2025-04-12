#!/bin/bash


## TODO: getopt for moving hidden files
### TODO: exclude hidden files without extenstion
## TODO: getopt for directory in which all operations will exec

script_dir=`realpath $0`
script_name=`basename $0`
script_extension=${0##*.}

## for just unhidden files

for file in `ls -p | grep -v '/'`
do
  extension=${file##*.}
  echo "$extension"
done | sort -u | while read ext
do
  [ ! -d $ext ] && mkdir $ext
  mv *.$ext $ext
done

mv $script_extension/$script_name $script_dir


##HELPING for hidden files
## Без dotglob, * не включает скрытые файлы
#ls * # Выводит только file1.txt
#
## Включаем dotglob
#shopt -s dotglob
#ls * # Выводит file1.txt .hidden_file1.txt .hidden_file2.txt
#
## Выключаем dotglob
#shopt -u dotglob
