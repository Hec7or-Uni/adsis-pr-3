# Práctica 3
**Autores:**
<br>**`Héctor Toral Pallás`**
<br>**`Francisco Javier Pizarro Martinez`** <br>
**Fecha: `09-04-2022`** <br>
**Grupo: `Miércoles-B 10-12am`**

---

## Diseño

Hemos decicido implementar la lógica de añadido y borrado de usuarios mediante funciones para hacer un código mas módular y legible.

<br>

```sh
  si no root entonces
    exit 1
  fsi

  si (numero de argumentos) != 2 entonces
    exit 1
  fsi

  si opcion == "-a" entonces
    loop users
      crearUsuario()
    floop
  si opcion == "-s" entonces
    loop users
      borrarUsuario()
    floop
  sino
    mostrar Opcion invalida
  fsi
```

<br>

### crearUsuario

```sh
  si params == "" entonces
    exit 1
  fsi

  crear usuario

  si usuario creado entonces
    contraseña -> usuario
    mostrar ___ ha sido creado
    usuario -> sudo
  sino
    mostrar El usuario ___ ya existe
  fsi
```

<br>

### borrarUsuario

```sh
  si (parametros erroneos) entonces
    exit 1
  fsi

  conseguir home del usuario
  si (hacer copia de backup) entonces
    eliminar usuario
  fsi
```