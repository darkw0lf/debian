#!/bin/bash

#Script Random Adress MAC generator

#### Initialisation des variables ###

compte=0
ok=not
version=1.0

#### Configuration ####

# Interface (eth0, eth1, wlan0...)
interface=wlan0

#Adresse mac d'origine
originalmac="00:1b:77:2b:61:56"

#### Fonctions ####

#Fonction d'intérogation
asking () {

echo "Veuillez sélectionner une option :"
echo ""
echo "	1. Changer l'adresse mac aléatoirement"
echo "	2. Restaurer l'adresse mac matériel"
echo "	3. Annuler"
read reponse
}

#Fonction de vérification de ROOT


if [ $USER = root ]
	then echo "Vous êtes root"
else
	echo "Vous n'êtes pas root, execution du script en sudo"
	sudo $0
	exit
fi

#Générateur d'adresse mac
macadress () {


	#Générateur d'aléatoire hexadécimal
	randomhexa () {

		#Fonction générateur de nombre
		random () {

		min=16
		max=255
		divisiblePar=1
		spread=$((max-min))
		random_binary=$(((RANDOM%(max-min+1)+min)/divisiblePar*divisiblePar))

		}


		#Convertisseur Hexadecimal
		hexadecimal () {

		base=16

		echo ""$1" "$base" o p" | dc
		return

		}

	
	

	fonc_hexa=`random && hexadecimal $random_binary`


	}



ad1=00
randomhexa
ad2=$fonc_hexa
randomhexa
ad3=$fonc_hexa
randomhexa
ad4=$fonc_hexa
randomhexa
ad5=$fonc_hexa
randomhexa
ad6=$fonc_hexa

random_mac_address="$ad1:$ad2:$ad3:$ad4:$ad5:$ad6"


}

#Fonction de changement d'adresse mac
mac_change () {
echo "Désactivation de l'interface réseau $interface"
if ifconfig $interface down
	then
		echo "Interface $interface désactivée"
		sleep 1
		echo "Changement de l'adresse MAC"
		if ifconfig $interface hw ether $mac_address
			then
				echo "L'adresse MAC de l'interface $interface été modifié"
				echo "Nouvelle adresse : $mac_address"
				sleep 1
				echo "Activation de l'interface réseau $interface"
				if ifconfig $interface up
					then
						echo "L'interface $interface a été réactivé et est prète à l'emploie"
						error=0
				else
					echo "ERREUR : L'interface $interface n'a pas pu être réactivé"
					error=1
				fi
		else
			echo "ERREUR : L'adresse MAC n'a pas pu être modifié"
			error=1
			sleep 2
			echo "Tentative de réactivation de l'interface $interface"
			if ifconfig $interface up
				then
					echo "L'interface $interface a été réactivé sans changement d'adresse MAC"
			else
				echo "ERREUR : L'interface $interface n'a pas pu être réactivé"
				error=1
			fi
		fi
else
	echo "ERREUR : Impossible de désactiver l'interface $interface"
	error=1
fi

}

#### Execution ####
echo "Bienvenue dans le programme de changement d'adresse MAC d'Aperture Science"
echo ""
echo ""

asking

until [ $ok = ok ]
 do
if [ $reponse = 1 ]
	then
		ok=ok
		macadress
		mac_address=$random_mac_address
		mac_change
		echo "L'execution du script s'autodétruira dans 10 sec"
		sleep 10
		exit $error
elif [ $reponse = 2 ]
	then
		ok=ok
		mac_address=$originalmac
		mac_change
		echo "L'execution du script s'autodétruira dans 10 sec"
		sleep 10
		exit $error
elif [ $reponse = 3 ]
	then
		echo "Abandon..."
		sleep 2
		exit 0
else
	echo "HEY ! Répondez correctement à la question..."
	asking
fi
done
