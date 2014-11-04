#!/bin/bash

while :
do
    clear
    cat<<EOF
    ==============================
    Menusystem experiment
    ------------------------------
    Please enter your choice:

    Harden VPS          (1)
    Install SabNZB      (2)
    Install SickBeard   (3)
    INstall Couchpotato (4)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")   ;;
    "2")  echo "you chose choice 2" ;;
    "3")  echo "you chose choice 3" ;;
    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
