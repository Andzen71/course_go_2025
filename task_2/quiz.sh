#!/bin/bash

## Установка глобальных переменных

echo "Введите своё имя: "
read name
IFS=$'\n'
BD_PATH=$1
OUT_DIR="./.out"
OUT_FILE=$OUT_DIR/${name}_`date +"%Y%m%d%H%M"`


## Проверка, что нужные программы установлены

important_apps=("csvtool")
needed_apps=("mlr")

try_app(){
	local cmd=$1
	if ! which $cmd &> /dev/null ; then return 1; else return 0 ; fi
}

for important_app in ${important_apps[@]}
do
	if ! try_app $important_app ; then
		echo "Ошибка: $important_app не установлен, программа не может корректно работать"
		exit 1
	fi
done

for needed_app in ${needed_apps[@]}
do
	if ! try_app $needed_app ; then
		echo "Предупреждение: $needed_app не установлен, программа может не корректно работать"
		declare ${needed_app}_flag=false
	fi
done


## Валидация переданного файла

help(){
	echo "Использование: quiz.sh [csv файл с вопросами и ответами]"
}

if [ -z $BD_PATH ]; then echo "Не передан файл"; help ; exit 2; fi 
if [ ! -f $BD_PATH ]; then echo "Ошибка: Нет файла с вопросами" >&2 ; exit 1; fi 
# С mlr мы проверяем валидный ли csv нам передали. Без не проверяем
if $mlr_flag; then
	mlr --csv cat $BD_PATH &> /dev/null
	if [[ $? -ne 0 ]]; then echo "Ошибка: Файл невалидный CSV" >&2 ; exit 1 ; fi
fi


## Существование конечной директории

if [ ! -d $OUT_DIR ] ; then mkdir $OUT_DIR; fi


## Основная логика

#Без csvtool
#while read -r line
#do
#	q=(`echo $line | awk -F '","' '{print $1}' | sed 's/^"//;s/"$//'`)
#	u=(`echo $line | awk -F '","' '{print $2}' | sed 's/^"//;s/"$//'`)
#done < $BD_PATH

questions=(`csvtool col 1 $BD_PATH`)
answers=(`csvtool col 2 $BD_PATH`)
quantity=$((`csvtool height $BD_PATH`-1))

for question_number in ${!questions[@]}
do
	if [ $question_number -eq 0 ]; then echo "Всего будет $quantity вопросов";
	else
		echo $question_number ${questions[$question_number]}
		read user_answer
		user_answers+=($user_answer)
		clear
	fi
done

for question_number in ${!questions[@]}
do
	if [ $question_number -eq 0 ]; then echo "Результаты" ; echo '"Вопросы","Ответы пользователя","Ответы"' > $OUT_FILE
	else
		echo $question_number ${questions[$question_number]}
		echo "Ваш ответ: "${user_answers[$question_number]}
		echo "Правильный ответ: " ${answers[$question_number]}
		echo "\"${questions[$question_number]}\",\"${user_answers[$question_number]}\",\"${answers[$question_number]}\"" >> $OUT_FILE
	fi
	echo "---------"
done
