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
    if [ -z "$NICKNAME" ]; then echo "Campo invalido"; exit 1
    elif [ -z "$PASSWD" ]; then echo "Campo invalido"; exit 1
    elif [ -z "$USERNAME" ]; then echo "Campo invalido"; exit 1; fi

    # añade un nuevo usuario
    useradd -U -m -k /etc/skel -K UID_MIN=1815 -K PASS_MAX_DAYS=30 -K PASS_WARN_AGE=3 -c "$USERNAME" "$NICKNAME" &>/dev/null

    if [ $? -eq 0 ]; then
        echo "${NICKNAME}:${PASSWD}" | chpasswd
        echo "$USERNAME ha sido creado"
        usermod -aG 'sudo' ${NICKNAME}
    else # username already in use
        echo "El usuario $1 ya existe"
    fi
}

deleteUser() {
    # comprueba que los campos no son ""
    if [ -z "${NICKNAME}" ]; then echo "Campo invalido"; exit 1; fi
    # Guarda el $HOME del usuario: ${NICKNAME}
    UHOME="$(getent passwd ${NICKNAME} | cut -d: -f6)"
    # Crea una copia de seguridad de los datos del usuario
    tar czvf "/extra/backup/${NICKNAME}.tar" "${UHOME}" &>/dev/null && userdel -f "${NICKNAME}" &>/dev/null
}

# añadir usuario
if [ $1 == "-a" ]; then
    while IFS=, read -r NICKNAME PASSWD USERNAME; do
        createUser "$NICKNAME" "$PASSWD" "$USERNAME"
    done < $2   # $2 = fichero con la informacion de los usuarios

# borrar usuario
elif [ $1 == "-s" ]; then
    if [ ! -d /extra ]; then mkdir -p /extra/backup
    elif [ ! -d /extra/backup ]; then mkdir /extra/backup; fi

    while IFS=, read -r NICKNAME BIN; do
        deleteUser "$NICKNAME" 
    done < $2   # $2 = fichero con la informacion de los usuarios

# error
else
    echo "Opcion invalida" 1>&2
fi

exit 0
