#! /bin/bash

##Script to simplify the change of any wireless card interface mode
##Detects and lists all available cards and their optional modes
##The user chooses what card to apply the chnages and the desired mode to run on it
##This script has a simple GUI for the user to make the chnages and describes all the process

##Author: Pedro Henrique Santos Sousa/henriquesantos293@gmail.com

##Begin Script

##Constants
 ##Variable to change the output text color to red
RED='\033[0;31m'
 ##Variable to change the output text color to green
GREEN='\033[1;32m'
 ##Variable to change the output text color to default
NOCOLOR='\033[0;m'
##Variable to change the output text color to dark grey
GREY='\033[1;30m'

echo
echo "----------------------- Wireless card interface mode toggler--------------------";
echo
echo "This is a Script to simplify the change of any wireless card interface mode.";
echo "It detects and lists all available cards and their optional modes.";
echo "You just have to choose wich wireless card you want to apply the changes and";
echo "wich available mode you want to run on it.";
echo
echo
echo  "This script needs the following dependencies installed so it can run properly:";
echo "-> ifconfig;";
echo "-> iwconfig;";
echo "-> iw;";
echo "-> grep;";
echo "-> sed;";
echo
echo
echo -n "Do you wish to run the Script? Yes(y) or No(n)?";
read ANSWER;
echo
if [ "$ANSWER" = "n" ]; then
	exit 0
fi
echo
echo
echo "Cheking for dependecies...";
##Check for dependencies
echo
echo -e "${GREY}Progress (1/5) - Checking if you have ifconfig installed...${NOCOLOR}";
echo
sleep 1s
##Check for ifconfig

if command -v ifconfig > /dev/null 2>&1; then
	echo -e "${GREEN}Good! you already have ifconfig installed on your machine.${NOCOLOR}"
	echo
else
	echo -e "${RED}It seems you don't have ifconfig installed on your machine.${NOCOLOR} "
	echo -n "Would you like to install it? Yes(y) or No(n)?";
	read ANSWER;
	echo
	if [ "$ANSWER" = "y" ]; then
		echo "Proceeding with the installation...";
		sudo apt-get update;
		sudo apt install net-tools -y;
		echo
	else
	 	echo -e "${RED}Exiting with code 127...${NOCOLOR} ";
		exit 127;
	fi
fi

echo -e "${GREY}Progress (2/5) - Checking if you have iwconfig installed...${NOCOLOR}";
echo
sleep 1s
##Check for iwconfig

if command -v iwconfig > /dev/null 2>&1; then
	echo -e "${GREEN}Good! you already have iwconfig installed on your machine.${NOCOLOR}"
	echo
else
	echo -e "${RED}It seems you don't have iwconfig installed on your machine.${NOCOLOR} "
	echo -n "Would you like to install it? Yes(y) or No(n)?";
	read ANSWER;
	echo
	if [ "$ANSWER" = "y" ]; then
		echo "Proceeding with the installation...";
		sudo apt-get update;
		sudo apt install wireless-tools -y;
		echo
	else
	 	echo -e "${RED}Exiting with code 127...${NOCOLOR} ";
		exit 127;
	fi
fi

echo -e "${GREY}Progress (3/5) - Checking if you have iw installed...${NOCOLOR}";
echo
sleep 1s
##Check for iw

if command -v iw > /dev/null 2>&1; then
	echo -e "${GREEN}Good! you already have iw installed on your machine.${NOCOLOR}"
	echo
else
	echo -e "${RED}It seems you don't have iw installed on your machine.${NOCOLOR} "
	echo -n "Would you like to install it? Yes(y) or No(n)?";
	read ANSWER;
	echo
	if [ "$ANSWER" = "y" ]; then
		echo "Proceeding with the installation...";
		sudo apt-get update;
		sudo apt install iw -y;
		echo
	else
	 	echo -e "${RED}Exiting with code 127...${NOCOLOR} ";
		exit 127;
	fi
fi

echo -e "${GREY}Progress (4/5) - Checking if you have grep installed...${NOCOLOR}";
echo
sleep 1s
##Check for grep

if command -v grep > /dev/null 2>&1; then
	echo -e "${GREEN}Good! you already have grep installed on your machine.${NOCOLOR}"
	echo
else
	echo -e "${RED}It seems you don't have grep installed on your machine.${NOCOLOR} "
	echo -n "Would you like to install it? Yes(y) or No(n)?";
	read ANSWER;
	echo
	if [ "$ANSWER" = "y" ]; then
		echo "Proceeding with the installation...";
		sudo apt-get update;
		sudo apt install grep -y;
		echo
	else
	 	echo -e "${RED}Exiting with code 127...${NOCOLOR} ";
		exit 127;
	fi
fi

echo -e "${GREY}Progress (5/5) - Checking if you have sed installed...${NOCOLOR}";
echo
sleep 1s
##Check for sed

if command -v sed > /dev/null 2>&1; then
	echo -e "${GREEN}Good! you already have sed installed on your machine.${NOCOLOR}"
	echo
else
	echo -e "${RED}It seems you don't have sed installed on your machine.${NOCOLOR} "
	echo -n "Would you like to install it? Yes(y) or No(n)?";
	read ANSWER;
	echo
	if [ "$ANSWER" = "y" ]; then
		echo "Proceeding with the installation...";
		sudo apt-get update;
		sudo apt install sed -y;
		echo
	else
	 	echo -e "${RED}Exiting with code 127...${NOCOLOR} ";
		exit 127;
	fi
fi
sleep 1s
echo
echo -e "${GREEN}You have all dependencies installed. Proceeding with the script...${NOCOLOR} ";
echo
echo
sleep 1s
##Scan for available wireless cards and display them
echo "Scanning for available wireless cards...";
sleep 1s
available_cards=$(ifconfig -a | egrep -o '^w\w*\b')
echo "Available wireless cards:";
echo -e "${GREEN}$available_cards${NOCOLOR} ";
echo
##Selection of one of the available cars
echo "Please select the wireless card you wish to change the interface mode from the list below:";
echo
select select_card in $available_cards NONE
do
		##Exit srcipt if none of the wireless cards is selected	
		if [ "$select_card" = "NONE" ]; then
			##Free local variables
			unset available_cards
			unset select_card
			exit 0
		fi

		##Exit loop
		break
done
echo
echo -e "Selected wireless card: ${GREEN}${select_card}${NOCOLOR}";
echo

##Scan for the selected card interface modes
echo "Scanning for available interface modes...";
sleep 1s
wiphyVAR=$(iw dev $select_card info | grep -oP '(?<=wiphy )[0-9]+') ##get iw info sor selected card, find digit for phy reference
available_mode=$(iw list | sed -n '/phy'$wiphyVAR'/,$p' | sed '1,/Supported interface modes:/d;/Band 1:/,$d' | sed -n -e 's/^.* //p') ##run iw->list and convert info into the right format
echo "Available interface modes:";
echo -e "${GREEN}$available_mode${NOCOLOR} ";
echo

##Selection of one of the available interface modes
echo "Please select one of the available modes from the list below:";
echo
select select_mode in $available_mode NONE
do
		##Exit srcipt if none of the wireless cards is selected	
		if [ "$select_mode" = "NONE" ]; then
			##Free local variables
			unset available_cards
			unset select_card
			unset select_mode
			unset available_mode
			unset wiphyVar
			exit 0
		fi

		##Exit loop
		break
done
echo
echo -e "Selected interface mode: ${GREEN}${select_mode}${NOCOLOR}";
echo
sleep 1s

##Change link state of selected card to down
sudo ifconfig $select_card down;
echo
if [ "$?" -eq "0" ]; then
	echo -e "Wireless card ${GREEN}$select_card${NOCOLOR} link state changed to: ${RED}down${NOCOLOR}";
fi
echo
sleep 1s

##Change the mode of the selected card
sudo iwconfig $select_card mode $select_mode;
echo
if [ "$?" -eq "0" ]; then
	echo -e "Wireless card ${GREEN}$select_card${NOCOLOR} mode changed to: ${GREEN}$select_mode${NOCOLOR}";
fi
echo
sleep 1s

##Change link state of selected card to up
sudo ifconfig $select_card up;
echo
if [ "$?" -eq "0" ]; then
	echo -e "Wireless card ${GREEN}$select_card${NOCOLOR} link state changed to: ${GREEN}up${NOCOLOR}";
fi
echo
sleep 1s

##Free local variables
unset available_cards
unset select_card
unset select_mode
unset available_mode
unset wiphyVar
unset RED
unset GREEN
unset NOCOLOR
unset GREY


##End script
echo 
echo -e "----------------------------${GREEN}INTERFACE MODE CHANGED${NOCOLOR}------------------------------";
echo
echo -e "---------------------------------${RED}END OF SCRIPT${NOCOLOR}----------------------------------";
echo	