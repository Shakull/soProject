#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: altera_taxa_portagem.sh
## Descrição/Explicação do Módulo: Toll's Record file Creator and Manager
##								
## @param $1: Highway SEGMENT (<Lanço>). Format: Origin-Destination. Ex: Lisboa-Porto
## @param $2: HIGHWAY name (<Auto-Estrada>). Format: A<nr>. Ex: A1, A2, A23
## @param $3: Cost of using the segment (<Taxa de Utilização>). Format: number. Ex: 10
##
###############################################################################

## FILE PATHS MANAGEMENT ##
#Permits changing file paths without changing script.
#WARNING! Changed files must have the same structure.
TOLLS_FILE=portagens.txt #File Structure: <ID_portagem>:<Lanço>:<Auto-estrada atribuída>:<Taxa de utilização (em créditos)>

#Temporary files.
TOLLS_TEMP_FILE=portagens.tmp


## INPUTS VALIDATION ##
#Checks if the number of arguments is lower than 3.
#@ERROR Invalid number of inputs.
if [[ $# -lt 3 ]];
	then
		./error 2
		exit
fi

#Checks if $1 is a valid SEGMENT. If not, returns @ERROR.
#@ERROR Invalid input arguments.
if ! [[ $1 = *"-"* ]];
	then
		./error 3 $1
		exit
fi

#Checks if $2 is a valid HIGHWAY. If not, returns @ERROR.
#@ERROR Invalid input arguments.
if ! [[ $2 = "A"* ]];
	then
		./error 3 $2
		exit
fi

#Checks if $3 is a number. If not, returns @ERROR.
#@ERROR Invalid input arguments.
if ! [[ $3 =~ ^[0-9]+$ ]];
	then
		./error 3 $3
		exit
fi


### MAIN ###

#Checks if TOLLS_FILE exists. If not, creates a new empty TOLLS_FILE.
if [ ! -f $TOLLS_FILE ];
	then
		touch $TOLLS_FILE
fi

#Checks if SEGMENT exists inside TOLLS_FILE.
if grep -q  $1 $TOLLS_FILE;

	then
		#Replaces that line's <Taxa de utilização>. Ignores <Auto-Estrada>'s value.
		#To save the new info, a temporary TOLLS_TEMP_FILE is used which then replaces TOLLS_FILE
		awk -v SEGMENT="$1" -v PRICE="$3" '{if ($2==SEGMENT) ($4=PRICE); print $0}' FS=":" OFS=":" $TOLLS_FILE > $TOLLS_TEMP_FILE && mv -f $TOLLS_TEMP_FILE $TOLLS_FILE
		
	else
		#A new entry is created:
		#Checks if TOLLS_FILE is empty
		if [ -z $TOLLS_FILE ]
			then
				#Sets current maximum ID to zero, since there are no records yet.
				ID=0
			else
				#Gets current maximum <ID_portagem> from TOLLS_FILE.
				ID=$(cat $TOLLS_FILE | cut -f1 -d":" $TOLLS_FILE | sort -n | tail -1)
		fi
		
		#Adds new entry to the end of TOLLS_FILE with given Arguments and the (maxId + 1) ID.
		echo $(($ID + 1))":"$1":"$2":"$3 >> $TOLLS_FILE

fi

#Returns confirmation of success.
./success 3 $1

#Sorts TOLLS_FILE alphabetically by <Auto-estrada> and then by <Lanço>.
#Returns confirmation of success and updated TOLLS_FILE view.
sort -k 3,3 -k 2,2 -t ':' $TOLLS_FILE | ./success 4