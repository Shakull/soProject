#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo: Scut-IUL Interface - Automatic Toll Payment Management System Platform.
##
##
###############################################################################

## EXTERNAL SCRIPTS ##
#Permits an easy directory management.
DRIVERS_LIST_SCRIPT=./lista_condutores.sh
TOLL_CHANGE_SCRIPT=./altera_taxa_portagem.sh
STATS_SCRIPT=./stats.sh
BILLING_SCRIPT=./faturacao.sh


### MAIN ###

#Runs MENU iteratively until EXIT option is chosen.
while :;
do
	#MENU options
	#Asks which action the user wants to run
	echo "1. Listar condutores"
	echo "2. Altera taxa de portagem"
	echo "3. Stats"
	echo "4. Faturação"
	echo "0. Sair"
	echo
	#Option selector via keyboard reader
	read -p "Opção: " opt
	echo

	#Chooses action based on user's previous input
	case $opt
	in
		1)
			#Runs DRIVERS_LIST_SCRIPT
			$DRIVERS_LIST_SCRIPT
			echo
			;;
			
		2)
			#Asks for INPUTS to run TOLL_CHANGE_SCRIPT
			echo "Altera taxa de portagem..."
			echo
			read -p "Lanço		: " segment
			read -p "Auto-estrada	: " motorway
			read -p "Novo valor taxa	: " cost
			echo
			
			#Runs TOLL_CHANGE_SCRIPT
			$TOLL_CHANGE_SCRIPT $segment $motorway $cost
			echo
			;;
			
		3)
			### Uncomment WHILE to make iterative STATS_MENU
#			#Runs STATS_MENU iteratively until RETURN option is chosen.
#			while :;
#			do
				#STATS_MENU options.
				#Asks which report the user wants to see.
				echo "Stats"
				echo
				echo "1. Nome de todas as Autoestradas"
				echo "2. Registos de utilização"
				echo "3. Listagem condutores"
				echo "0. Voltar"
				echo
				read -p "Opção: " statsOpt
				
				#Runs STATS_SCRIPT for that report.
				case $statsOpt
				in
					1)
						#Returns a report of all Highways with at least one Segment registered on the platform.
						echo
						$STATS_SCRIPT "listar"
						echo
						continue
						;;
					
					2)
						#Asks Minimum Number of Records. Used to filter out each Segment that has lesser records than the given number.
						read -p "Mínimo de registos	: " statsOpt2
						echo
						
						#Returns a report of all Highways that have at least one Segment registered on the platform.
						$STATS_SCRIPT "registos" $statsOpt2
						echo
						continue
						;;
					
					3)
						#Returns a report of all Active Drivers registered on the platform.
						#Active Driver: a Driver that has at least one Toll Usage registered on the platform.
						echo
						$STATS_SCRIPT "condutores"
						echo
						continue
						;;
					
					0)
						#Returns to previous menu (MENU)
						echo
						break
						;;
					
					*)
						#If invalid input, returns @ERROR and summons STATS_MENU again.
						#@ERROR Invalid input arguments.
						echo
						./error 3 $statsOpt
						echo
						echo "Selecione uma das opções apresentadas:"
						continue
						;;
				esac
#			done
			;;
			
		4)
			#Runs BILLING_SCRIPT
			$BILLING_SCRIPT
			echo
			;;
			
		0)
			#Closes interface.
			exit
			;;
			
		*)
			#If invalid input, returns @ERROR and summons MENU again.
			#@ERROR Invalid input arguments.
			./error 3 $opt
			echo
			echo "Selecione uma das opções apresentadas:"
			echo
			continue
			;;
	esac
done