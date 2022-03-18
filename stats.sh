#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: stats.sh
## Descrição/Explicação do Módulo: Reports for Scut-IUL - Automatic Toll Payment Management System Platform.
##					
## @param $1: 
##      "listar"	:	Shows a list of all Highways with at least one Segment registered on the platform. Ex: ./stats "listar"
##      "registos"	:	Shows a list of all SEGMENTs that were used more than $2 times. Ex: ./stats "registos" 2
##			@param $2: minimum number of records to consider)
##      "condutores":	Shows a list of all Active Drivers registered on the platform. Ex: ./stats "condutores"
## 
###############################################################################

##############################################################
##	FILE PATHS MANAGEMENT									##
##############################################################

#Permits changing file paths without changing script.
#WARNING! Changed files must keep the same structure.

TOLLS_FILE=portagens.txt #File Structure: <ID_portagem>:<Lanço>:<Auto-estrada atribuída>:<Taxa de utilização (em créditos)>
TOLLS_RECORD_FILE=relatorio_utilizacao.txt #File Structure: <ID Portagem>:<Lanço>:<ID Condutor>:<Matrícula>:<Taxa_Portagem>:<Data>
DRIVERS_FILE=condutores.txt #File Structure: <ID>-<Nome>;<ID carta condução>;<Contacto>;<Nr Contribuinte>;<Saldo (em créditos)>

#Temporary files.
DRIVERS_TEMP_FILE=condutores.tmp
TOLLS_RECORD_TEMP_FILE=relatorio_utilizacao.tmp


##############################################################
##	INPUTS VALIDATION										##
##############################################################

#Checks if there is at least one argument. If not, returns @ERROR and exits.
#@ERROR Invalid number of inputs.
if [ -z $1 ]; then
	./error 2
	exit
fi


##############################################################
##	MAIN													##
##############################################################

case $1
in
	"listar")
		#Gets a list of all Highways with registered segments.
		cat $TOLLS_FILE | awk -F ':' '{print $3}' | sort | uniq | ./success 6
		;;
		
	"registos")
		#Checks if there is a 2nd argument. If not, returns @ERROR and exits.
		#@ERROR Invalid number of inputs. 
		if [ -z $2 ]; then
			./error 2
			exit
			
			else
				#Checks if 2nd argument is valid. Condition: must be a number greater than 0. Else, returns @ERROR.
				#@ERROR Invalid input arguments.
				if [ ! $2 -gt 0 ]; then
					./error 3 $2
					exit
				fi
		fi
		
		#Creates tmp file to save temporary toll records.
		touch $TOLLS_RECORD_TEMP_FILE
		#Gets SEGMENTs that were used.
		SEGMENT=$(cat $TOLLS_RECORD_FILE | awk -F ':' '{print $2}' | sort | uniq)
		
		#Gets number of records for each SEGMENT
		for i in $SEGMENT
			do
				#Gets a list of each SEGMENT and its respective Record Count and saves to TOLLS_RECORD_TEMP_FILE
				echo $i $(cat $TOLLS_RECORD_FILE | awk -F":" -v seg=$i '$2==seg {print $0}' | wc -l) >> $TOLLS_RECORD_TEMP_FILE
			done
		
		#Gets all SEGMENTS that have a Count equal or higher than 2nd argument.
		#Returns confirmation of success and a list with all those SEGMENT Names.
		cat $TOLLS_RECORD_TEMP_FILE | awk -v arg2=$2 '($2 >= arg2) {print $1}' | ./success 6
		#Removes tmp file.
		rm $TOLLS_RECORD_TEMP_FILE
		
		exit
		;;
	
	"condutores")
		#Gets Clients IDs that used at least one TOLL
		CLIENTS_ID=$(cat $TOLLS_RECORD_FILE | awk -F ':' '{print $3}' | sort | uniq )

		#Creates tmp file to save all active Drivers ID
		touch $DRIVERS_TEMP_FILE
		#Gets Driver Name for each active Driver ID
		for i in $CLIENTS_ID
			do
				#Gets Client Name from DRIVERS_FILE by ClientID and adds it to DRIVERS_TEMP_FILE
				cat $DRIVERS_FILE | awk -F["-;"] -v ID=$i '$1==ID {print $2}' >> $DRIVERS_TEMP_FILE
							
			done
		
		#Returns confirmation of success and an Active Drivers List.
		cat $DRIVERS_TEMP_FILE | ./success 6
		#Removes tmp file.
		rm $DRIVERS_TEMP_FILE
		exit
		;;
		
	*)
		#Returns @ERROR and exits if no valid arguments were selected
		#@ERROR Invalid input arguments.
		./error 3 $1
		exit
		;;
esac