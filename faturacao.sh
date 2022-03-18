#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: faturacao.sh
## Descrição/Explicação do Módulo: Billing report creator for Scut-IUL
##
##		Report Structure:						|Ex:
##												|
##			Cliente: <Client Name>				|	Client: John Doe
##			<TOLLS RECORD>						|	1:Cartaxo-Santarém:ID234580880:12-HT-62:5:21/02/2022
##			(...)								|	14:Lisboa-Porto:ID234580880:12-HT-62:10:17/02/2022
##												|
##			Total: <sum of TOLLS> créditos		|	Total: 10 créditos
##												|
##												|	Cliente: (...)
##
###############################################################################

## FILE PATHS MANAGEMENT ##
#Permits changing file paths without changing script.
#WARNING! Changed files must have the same structure.
TOLLS_RECORD_FILE=relatorio_utilizacao.txt #File Structure: <ID Portagem>:<Lanço>:<ID Condutor>:<Matrícula>:<Taxa_Portagem>:<Data>
PEOPLE_FILE=pessoas.txt #File Structure: <ID carta condução>:<Nome>:<Nr Contribuinte>:<Contacto>

##OUTPUT File Paths.
BILLING_FILE=faturas.txt


## INPUTS VALIDATION ##
#Checks if TOLLS_RECORD_FILE exists in the current directory. If not, returns @ERROR.
#@ERROR Non-existant file.
if [ ! -f $TOLLS_RECORD_FILE ];
	then
		./error 1 $TOLLS_RECORD_FILE
		exit
fi

#Checks if BILLING_FILE exists in the current directory and removes it.
if [ -f $BILLING_FILE ];
	then
		rm $BILLING_FILE
fi

#Checks if BILLING_FILE is empty and exits.
if [ -s $BILLING_FILE ];
	then
		exit
fi


### MAIN ###

#Gets PEOPLE IDs from PEOPLE_FILE
PEOPLE_ID=$(cat $PEOPLE_FILE | awk -F[:] '{print "ID" $3}')

#Gets active CLIENTS IDs from TOLLS_RECORD_FILE
ACTIVE_CLIENTS_ID=$(cat $TOLLS_RECORD_FILE | awk -F ':' '{print $3}' | sort | uniq )


##Writes the OUTPUT report per ACTIVE CLIENT on BILLING_FILE.
##
##	Report Structure per Client:			|Ex:
##											|
##		Cliente: <Client Name>				|	Client: John Doe
##		<TOLLS RECORD>						|	1:Cartaxo-Santarém:ID234580880:12-HT-62:5:21/02/2022
##		(...)								|	14:Lisboa-Porto:ID234580880:12-HT-62:10:17/02/2022
##											|
##		Total: <sum of TOLLS> créditos		|	Total: 10 créditos
###
for person in $PEOPLE_ID
	do
		for active_person in $ACTIVE_CLIENTS_ID
			do
				#Checks if person is active.
				if [ $person == $active_person ];
					then
						#Gets person ID without 'ID'. Ex: ID987654321 > 987654321
						personVat=$(echo $person | cut -c3-)
						#Writes Client Name from PEOPLE_FILE
						echo "Cliente:" $(cat $PEOPLE_FILE | awk -F':' -v ID=$personVat '$3==ID {print $2}') >> $BILLING_FILE
						#Writes all Tolls registered on this Client from TOLLS_RECORD_FILE
						cat $TOLLS_RECORD_FILE | awk -v ID=$person '$3==ID {print $0}' FS=":" OFS=":" >> $BILLING_FILE
						#Writes the total ammount spent on tolls by this Client.
						echo "Total:" $(cat $TOLLS_RECORD_FILE | awk -F":" -v ID=$person '$3==ID {sum += $5} END {print sum}') "créditos" >> $BILLING_FILE
						#Writes an empty line to devide each Client's BILL
						echo >> $BILLING_FILE
						continue
				fi
			done
	done

#Returns confirmation of success and an updated BILLING_FILE view.	
./success 5 $BILLING_FILE