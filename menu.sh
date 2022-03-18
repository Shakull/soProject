#!/bin/bash

###############################################################################
## ISCTE-IUL: Trabalho prático de Sistemas Operativos 2021/2022
##
## Aluno: Nº: 103955  Nome: Diogo Ribeiro
## Nome do Módulo: menu.sh
## Descrição/Explicação do Módulo: Scut-IUL's Interface - Automatic Toll Payment Management System.
##
##
###############################################################################

##############################################################
##	SCRIPT PATHS MANAGEMENT									##
##############################################################

#Permits an easy directory management.
#WARNING! Scripts must keep their INPUT/OUTPUT structure.

DRIVERS_LIST_SCRIPT=./lista_condutores.sh
TOLL_CHANGE_SCRIPT=./altera_taxa_portagem.sh
STATS_SCRIPT=./stats.sh
BILLING_SCRIPT=./faturacao.sh


##############################################################
##	MAIN													##
##############################################################

#Runs MENU iteratively until EXIT option is chosen.
while :;
do
	#MENU Options
	#Asks which action the user wants to run
	echo "1. Listar condutores"
	echo "2. Altera taxa de portagem"
	echo "3. Stats"
	echo "4. Faturação"
	echo "0. Sair"
	echo
	#Scans user INPUT choice
	read -p "Opção: " opt
	echo

	#Chooses action based on user's INPUT
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
			read -p "Auto-estrada	: " highway
			read -p "Novo valor taxa	: " cost
			echo
			
			#Runs TOLL_CHANGE_SCRIPT
			$TOLL_CHANGE_SCRIPT $segment $highway $cost
			echo
			;;
			
		3)
#||	OPTIONAL - Iterative Stats Menu###
#||		Uncomment WHILE to make iterative STATS_MENU.
#||		HOW TO: remove '###' from all lines starting with ###.
#||
###			#Runs STATS_MENU iteratively until RETURN option is chosen.
###			while :;
###			do
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
						;;
					
					2)
						#Asks Minimum Number of Records. Used to filter out each Segment that has lesser records than the given number.
						read -p "Mínimo de registos	: " statsOpt2
						echo
						
						#Returns a report of all Highways that have at least one Segment registered on the platform.
						$STATS_SCRIPT "registos" $statsOpt2
						echo
						;;
					
					3)
						#Returns a report of all Active Drivers registered on the platform.
						#Active Driver: a Driver that has at least one Toll Usage registered on the platform.
						echo
						$STATS_SCRIPT "condutores"
						echo
						;;
					
					0)
						#Returns to previous menu (MENU)
						echo
###						break
						;;
					
					*)
						#If invalid input, returns @ERROR and summons STATS_MENU again.
						#@ERROR Invalid input arguments.
						echo
						./error 3 $statsOpt
						echo
###						echo "Selecione uma das opções apresentadas:"
						;;
				esac
###			done
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
			;;
	esac
done