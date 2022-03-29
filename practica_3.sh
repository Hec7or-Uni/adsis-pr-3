#!/bin/bash
#798095, Toral Pallas, Hector, M, 3, B
#821259, Pizarro Martínez, Francisco Javier, M, 3, B

# comprueba permisos de root
if [ $EUID -ne 0 ]; then
    echo "Este script necesita privilegios de administracion"
    exit 1
fi

# comprueba numero de parametros
if [ $# -ne 2 ]; then
    echo "Numero incorrecto de parametros"
    exit 1
fi

createUser() {
    # comprueba que los campos no son ""
    if [ -z $1 ]; then; echo "Campo invalido"; exit 1
    elif [ -z $2 ]; then; echo "Campo invalido"; exit 1
    elif [ -z $3 ]; then; echo "Campo invalido"; exit 1; fi

    # añade un nuevo usuario
    useradd -Umkc /etc/skel "$3" UID_MIN=1815 PASS_MAX_DAYS=30 PASS_WARN_AGE=3 &> /dev/null
    if [ $? -eq 0 ]; then
        echo "$1:$2" | chpasswd
        echo "$3 ha sido creado"
    else # username already in use
        echo "El usuario $1 ya existe"
    fi
}

deleteUser() {
    # borra un usuario y crea una copia de seguridad de los datos de este
    deluser -f ${$1} --backup --backup-to "/extra/backup/" --remove-home &>/dev/null;
    if [ $? -eq 0 ]; then tar -xf "/extra/backup/${1}.tar.gz"; fi
}

# añadir usuario
if [ $1 == "-a" ]; then
    while IFS=, read -r NICKNAME PASSWD USERNAME; do
        createUser $NICKNAME $PASSWD $USERNAME
    done < $2   # $2 = fichero con la informacion de los usuarios

# borrar usuario
elif [$1 == "-s"]; then
    if [ ! -d /extra ]; then mkdir -p /extra/backup
    elif [ ! -d /extra/backup ]; then mkdir /extra/backup; fi

    while IFS=, read -r NICKNAME; do
        deleteUser $NICKNAME
    done < $2   # $2 = fichero con la informacion de los usuarios

# error
else
    echo "Opcion invalida" 1>&2
fi

exit 0