# Sesion 3: Manejo de datos

En esta sesión, vamos a usar comandos básicos para:
- explorar datos de genotipos
- fusionar datos
- filtrar por valores faltantes, Frecuencia del Alelo Menor (MAF), Desequilibrio de Ligamimiento (LD)

## Conocer los datos

### Explorar los ficheros

Vamos a ver a que se parecen los datos en el formato eigensoft.

Vamos a trabajar desde 3 archivos al formato EIGENSOFT:
- Datos de genotipificación de individuos modernos ( de la Fuente et al. 2018 y Luisi et al. 2020). Estos datos fueron enmascarados por individuo para quedarse solo con las regiones genomicas de ancestria genetica indigena (para cada individuo, los genotipos de las variantes en regiones con ancestria genetica no indigena fueron asignados a Valor Faltante). En `StartingData/MaskedModernData/
- Datos de secuenciacion de individuos antiguos (de la Fuente et al. 2018, Nakatsuka et al. 2020, Raghavan et al. 2015), obtenidos desde el [Allen Ancient DNA Resource (AADR)](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/FFIDCW). En `StartingData/AADR/`
- Datos de secuenciacion de individuos modernos de Francia (French), de Nigeria (Yoriba) y Congo (Mbuti). En `StartingData/Outgroups/`

Los datos de genotipos en el formato eigensoft se conforman de 3 archivos (ver : [https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README](https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README)) 
- `<pref>.snp.txt`: el mapa de las variantes con 6 columnas: snpID | chr | position (in cM) | position (in bp) | Allele1 | Allele2
- `<pref>.ind.txt`: informacion de los individuos con 3 columnas indID | Sex | Population
- `<pref>.geno.txt`: la matrix de genotipos (1 linea por individuo, una columna por variante; los individuos y las variantes estan en el mismo orden que en el .ind.txt y el .snp.txt). El genotipo esta codificado con el numero de copias del Alelo1 (0/1/2 y 9 para valor faltante).

En la terminal. Ubicar se en ${HOME}/JNAB/dia1/sesion3/:

` cd ${HOME}/JNAB/dia1/sesion3/ `

Los datos estan en StartingData.

Buscar con `ls` los nombres de los archivos para AADR (ADN antiguo).

Verificar que los numeros entre los archivos concuerden:
- Obtener numero de variantes (numero de lineas en el archivo <pref>.snp.txt con `wc -l <pref>.snp.txt).
- Obtener numero de individuos (numero de lineas en el archivo <pref>.ind.txt con `wc  -l <pref>.ind.txt).
- Obtener numero de caracteres en la matriz de genotipos con `wc -m <pref>.geno.txt`
- Obtener numero de lineas en la matriz de genotipos con `wc -l <pref>.geno.txt`

Son consistentes estos numeros?

Con `head <nombre del archivo> ` mirar las 10 primeras lineas del mapa, de los individuos y de la matriz de genotipos.
- Cuales son los alelos de las 5 primeras variantes? (Se puede mostrar solamente las 5 primeras lineas con `head -5 <pref>.snp.txt`)
- A que poblaciones pertenecen los 3 primeros individuos? (se puede mostrar solamente las 3 primeras lineas con `head -3 <pref>.ind.txt`)
- Cual es el genotipo de lo 3 primeros individuos para las 5 primeras variantes? (se puede mostrar estos genotipos con `head -5 <pref>.geno.txt | awk -F "" '{print $1,$2,$3}' `

### Obtener informacion sobre los 3 conjuntos de datos con los cuales queremos trabajar

Mirar el script ` 0_init.sh `: permite crear carpetas que nos van a servir despues.  

Mirar el script: ` 1_getSomeNumbers.sh `. Con un bucle `for`, va a sacar diferentes numeros de los archivos. El bucle `for ` permite hacer las mismas acciones usando la variable `base` a la cual se atribuye el prefijo de cada triplet de archivos que nos interesan. Estos numeros se escriben luego en archivo de salidas guardados en la carpeta `Outputs/`.

Correr el script: ` ./1_getSomeNumbers.sh `, y mirar las salidas.
- Cuantas variantes y cuantos individuos contienen cada conjunto de datos? Cuantos individuos?
- Cuantos individuos por poblacion?
- Que cromosomas estan representados?


## Fusionar datos

### Primer intento
Ahora vamos a intentar fusionar los datos de individuos modernos y Antiguos con la [funcion mergeit de eigensoft](https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README).

Mirar el archivo `2_merge_AADR-Modern.sh`.
El header con SBATCH son las especificaciones para mandar a correr el script en un nodo de computacion:
- vamos a usar la particion que se llama short (`#SBATCH -p short`)
- lo  que normalmente se imprimiria en la plantalla si corremos el script directamente (es decir el stdout) se guardaran en `/home/pluisi/JNAB/dia1/sesion3/Logs/merge.o`
- los errores que normalmente se imprimiria en la plantalla si corremos el script directamente (es decir el stderr) se guardaran en `/home/pluisi/JNAB/dia1/sesion3/Logs/merge.e`
- el job aparecera como `merge` en la cola (`#SBATCH -J merge `)
Luego vienen las instrucciones: 
- las lineas `shopt -s expand_aliases
source ~/.bash_profile ` son algunos trucos para poder correr los programas (es propio de como organizamos la instalacion de los programas en el cluster y no lo vamos a explicar).
- `base1=${HOME}/JNAB/dia1/sesion3/StartingData/AADR/AADR_selected`
- `base2=${HOME}/JNAB/dia1/sesion3/StartingData/AADR/AADR_selected`
- `format=PACKEDBED` es para asignar el formato de salida (plink)
- `outpref=...` es para asignar los nombres de los archivos de entrada y de salida, mientras que `format=...` es para asignar el formato.
- `echo ... ` es para generar el archivo `Outputs/ModernAncient.params `
- `mergit -p ... ` es para correr mergeit con este fichero de parametros.

Mandar a correr el job con `sbatch 2_merge_AADR-Modern.sh`.

Mirar el estatus de la cola con `squeue -u <user> ` (su user es `cursojnab<N>`). Cuando no aparece mas es que se acabo la corrida.

Funciono? Mirar los Logs (`Logs/merge.e` y `Logs/merge.o`) y verificar si se generaron los archivos esperados en `Outputs/`

Los archivos estan al formato "binary" de plink y se constituyen de 3 archivos
- `<pref>.bim`: mapa de las variantes con 6 columnas chr | snpID | posicion (en cM) | posicion (en bp) | Alelo1 | Alelo2 (ver [https://www.cog-genomics.org/plink/1.9/formats#fam](https://www.cog-genomics.org/plink/1.9/formats#bim)
- `<pref>.fam`: informacion sobre los individuos FamilyID | IndID |  fatherID |  motherID | Sex | Phenotype (ver [https://www.cog-genomics.org/plink/1.9/formats#fam](https://www.cog-genomics.org/plink/1.9/formats#fam))
- `<pref>.bed: matriz de genotipos (binario y no se puede leer directamente; ver [https://www.cog-genomics.org/plink/1.9/formats#fam](https://www.cog-genomics.org/plink/1.9/formats#bed).

 
Vemos que no le gusta que los alelos no sean consistentes entre los dos archivos. Eso se debe a que puede ser una posicion tri-allelica pero eigensoft (y plink) solo reconocen posiciones bi-allelica.
Pero ademas cuando trabajamos con datos de genotipificacion, existe el problema de la cadena: un A leido en la cadena + corresponde a un T en la cadena -. Lo mismo para C/G. Llamamos los genotipos A/T y C/G "ambiguos". Cuando trabajamos con datos de secuenciacion, en general todo se lee con la cadena + y no hay ambiguidad, pero con datos de genotipificacion, es mas complicado (depende de la poisicion y de la tecnologia), entonces es recomendable sacar las posiciones con alelos A/T y C/G. Es lo que hace eigensoft.

Con `wc -l Outputs/ModernAncient.bim ` se puede consultar cuantas posiciones quedaron.
Con ` awk '{print $5,$6}' Outputs/ModernAncient.bim | sort | uniq ` se puede ver el conteo de las combinaciones Alelo1/Alelo2 de las variantes que quedan, y verificar que ya no hay genotipos ambiguois.
Con ` wc -l  Outputs/ModernAncient.fam `  podemos ver el numero de individuos (corroborar que corresponde con los inputs).




 









 

