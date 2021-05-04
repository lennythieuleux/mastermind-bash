#!/bin/bash

continuer(){
    echo "APPUIES sur ENTRER pour continuer..."
    read
    clear
}

generateCombination(){
    #STEP A.1 : generer la combinaison
    letter=ABCDEFGH

    x=0

    while [ $x -lt 4 ]
    do
    i=${letter:$(( RANDOM % ${#letter} )):1}
    randomLetter=$randomLetter$i
    x=$(( $x + 1 ))
    done

    echo "Ordinateur propose :" $randomLetter
}

checkWin(){
    #Vérifie sur la réponse est bonne : si bonne, affiche vous avez gagné
    #ou Réinitialise la var réponse si réponse fausse et moins de 10 essais
    #Sinon affiche vous avez perdu
    if [[ $1 == "2" ]]  && [[ "$answer" == "OOOO" ]];then
        if [[ $(($try % 2)) -eq 0 ]]; then
        echo "Félicitations, "$playerOne", tu as gagné !"
        break
        else
            echo "Félicitations, "$playerTwo", tu as gagné !"
            break
        fi
    elif [[ "$answer" == "OOOO" ]]
    then
        echo "Félicitations, vous avez gagné !"
        break
    elif [[ $try -lt $maxTry ]]
    then
        answer=""
    else
        echo "Vous avez perdu !"
    fi
}

multiPlayerMode(){
    if [[ "$1" == "2" ]];then
    $2
    else
    echo ""
    fi
}

getPlayersName(){
    #STEP B.1 : Demander les noms des joueurs
    echo "Joueur 1, quel est ton nom ?"
    read -r playerOne

    continuer    

    echo "Joueur 2, quel est ton nom ?"
    read -r playerTwo

    continuer
}

whosTurn(){
    #Affiche à quel joueur c'est le tour de jouer
    if [[ $(($try % 2)) -eq 0 ]]; then
    echo $playerOne", à toi de jouer !"
    else
    echo $playerTwo", c'est ton tour !"
    fi
}

playMastermind(){

    nbPlayer=$1

    if [[ "$nbPlayer" == "1" ]];then
        maxTry=10
    else
        maxTry=20
    fi
    
    generateCombination

    multiPlayerMode $nbPlayer getPlayersName

    #STEP A.2 : joueur propose sa combinaison
    try=0

    while [ $try -lt $maxTry ]
    do

        multiPlayerMode $nbPlayer whosTurn

        echo "Saisissez une combinaison : "
        read -r userChoice

        xVerif=0
        while [ $xVerif -lt 4 ]
        do
            if [ ${randomLetter:$xVerif:1} == ${userChoice:$xVerif:1} ]
            then
                answer=$answer"O"
            elif [[ "$randomLetter" == *"${userChoice:$xVerif:1}"* ]]
            then
                answer=$answer"P"
            else
                answer=$answer"X"
            fi

        xVerif=$(( $xVerif + 1 ))
        done

        #STEP A.3 : Ordinateur répond
        echo "Résultat : "$answer

        #Si joueur gagne avant fin des 10 essais
        checkWin $nbPlayer

        try=$(( $try + 1 ))

        multiPlayerMode $nbPlayer continuer

    done
    if [ $try == $maxTry ]
    then
    checkWin $nbPlayer
    fi
}


#Ordinateur demande nombre de joueurs
echo "Combien y-a-t'il de joueur(s) ?  [Réponse acceptée : 1 ou 2]"
read -r nbPlayer
clear

until [ "$nbPlayer" == "1" ] || [ "$nbPlayer" == "2" ]
do
    echo "Erreur... \nCombien y-a-t'il de joueur(s) ?  [Réponse acceptée : 1 ou 2]"
    read -r nbPlayer
    clear
done

playMastermind $nbPlayer








