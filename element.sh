#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#check if there is an argument or not
if [[ -z $1 ]]
then echo "Please provide an element as an argument."
else
#check if it's a number 
if [[ $1 =~ ^[0-9]+$ ]]
then INPUT=$($PSQL "SELECT elements.atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, name, symbol 
FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON types.type_id = properties.type_id WHERE properties.atomic_number = $1;")
if [[ -z $INPUT ]]
then echo "I could not find that element in the database."
else 
IFS="|" read ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING BOILING NAME SYMBOL <<< "$INPUT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
else
#if it's a word or a letter
INPUT=$($PSQL "SELECT elements.atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, name, symbol 
FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON types.type_id = properties.type_id WHERE elements.symbol = '$1' OR elements.name = '$1';")
if [[ -z $INPUT ]]
then echo "I could not find that element in the database."
else 
IFS="|" read ATOMIC_NUMBER TYPE ATOMIC_MASS MELTING BOILING NAME SYMBOL <<< "$INPUT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
fi
fi
