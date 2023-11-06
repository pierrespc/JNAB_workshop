# Sesión 3: Manejo de datos

En esta sesión, vamos a usar comandos básicos para:
- explorar datos de genotipos
- fusionar datos
- filtrar por valores faltantes, Frecuencia del Alelo Menor (MAF), Desequilibrio de Ligamimiento (LD)

## 1. Conocer los datos

### 1.1. Explorar los ficheros

Vamos a ver a que se parecen los datos en el formato eigensoft.
Vamos a trabajar con 3 conjuntos de datos:
- Datos de genotipificación de individuos modernos ( de la Fuente et al. 2018 y Luisi et al. 2020). Estos datos fueron enmascarados por individuo para quedarse solo con las regiones genómicas de ancestria genética indigena (para cada individuo, los genotipos de las variantes en regiones con ancestría genética no indígena fueron asignados a Valor Faltante). En `StartingData/MaskedModernData/
- Datos de secuenciación de individuos antiguos (de la Fuente et al. 2018, Nakatsuka et al. 2020, Raghavan et al. 2015), obtenidos desde el [Allen Ancient DNA Resource (AADR)](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/FFIDCW). En `StartingData/AADR/`
- Datos de secuenciación de individuos modernos de Francia (French), de Nigeria (Yoruba) y Congo (Mbuti). En `StartingData/Outgroups/`

Los datos de genotipos en el formato eigensoft se conforman de 3 archivos (ver : [https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README](https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README)) 
- `<pref>.snp.txt`: el mapa de las variantes con 6 columnas: snpID | chr | position (in cM) | position (in bp) | Alelo1 | Alelo2
- `<pref>.ind.txt`: información de los individuos con 3 columnas indID | Sex | Population
- `<pref>.geno.txt`: la matriz de genotipos (1 línea por individuo, una columna por variante; los individuos y las variantes están en el mismo orden que en los archivos  `.ind.txt` y el `.snp.txt`). El genotipo está codificado con el número de copias del Alelo1 (0/1/2 y 9 para valor faltante).

En la terminal: Ubicarse en ${HOME}/JNAB/dia1/sesion3/: ` cd ${HOME}/JNAB/dia1/sesion3/ `

Los datos están en la carpeta `StartingData`.
Buscar con `ls` los nombres de los archivos para AADR (ADN antiguo).

Verificar que los números entre los archivos concuerden:
- Obtener número de variantes (número de líneas en el archivo <pref>.snp.txt con `wc -l <pref>.snp.txt).
- Obtener número de individuos (numero de líneas en el archivo <pref>.ind.txt con `wc  -l <pref>.ind.txt).
- Obtener número de cáracteres en la matriz de genotipos con `wc -m <pref>.geno.txt`
- Obtener número de líneas en la matriz de genotipos con `wc -l <pref>.geno.txt`

Son consistentes estos números?

Con `head <nombre del archivo> ` mirar las 10 primeras líeas del mapa, de los individuos y de la matriz de genotipos.
- Cuáles son los alelos de las 5 primeras variantes? (Se puede mostrar solamente las 5 primeras líneas con `head -5 <pref>.snp.txt`)
- A qué poblaciones pertenecen los 3 primeros individuos? (se puede mostrar solamente las 3 primeras líneas con `head -3 <pref>.ind.txt`)
- Cuál es el genotipo de lo 3 primeros individuos para las 5 primeras variantes? (se puede mostrar estos genotipos con `head -5 <pref>.geno.txt | awk -F "" '{print $1,$2,$3}' `

### 1.2. Obtener información sobre los 3 conjuntos de datos con los cuales queremos trabajar

Mirar el script ` 0_init.sh `: permite crear carpetas que nos van a servir después.  

Mirar el script: ` 1_getSomeNumbers.sh `. El bucle `for ` permite hacer las mismas acciones usando la variable `base` a la cúal se atribuye el prefijo de cada triplet de archivos que nos interesan. Estos números se escriben luego en archivo de salidas guardados en la carpeta `Outputs/`.

Correr el script: ` ./1_getSomeNumbers.sh `, y mirar las salidas.
- Cuántas variantes y cuantos individuos contienen cada conjunto de datos? Cuantos individuos?
- Cuántos individuos por poblacion?
- Qué cromosomas están representados?


## 2. Fusionar datos

### 2.1. Modern + AADR
Ahora vamos a intentar fusionar los datos de individuos modernos y Antiguos con la [funcion mergeit de eigensoft](https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README).

Mirar el archivo `2_merge_AADR-Modern.sh`.
El encabezado con SBATCH son las especificaciones para mandar a correr el script en un nodo de computaciónn:
- vamos a usar la partición que se llama short (`#SBATCH -p short`)
- lo  que normalmente se imprimiría en la plantalla si corremos el script directamente (es decir el stdout) se guardará en `/home/pluisi/JNAB/dia1/sesion3/Logs/merge.o`
- los errores que normalmente se imprimirían en la plantalla si corremos el script directamente (es decir el stderr) se guardarán en `/home/pluisi/JNAB/dia1/sesion3/Logs/merge.e`
- el job aparecerá cómo `merge` en la cola (`#SBATCH -J merge `)
Luego vienen las instrucciones: 
- las líneas `shopt -s expand_aliases
source ~/.bash_profile ` son algunos trucos para poder correr los programas (es propio de como organizamos la instalación de los programas en el cluster y no lo vamos a explicar).
- `base1=${HOME}/JNAB/dia1/sesion3/StartingData/AADR/AADR_selected`
- `base2=${HOME}/JNAB/dia1/sesion3/StartingData/AADR/AADR_selected`
- `format=EIGENSTRAT` es para asignar el formato de salida (plink)
- `outpref=...` es para asignar los nombres de los archivos de entrada y de salida, mientras que `format=...` es para asignar el formato.
- `echo ... ` es para generar el archivo `Outputs/ModernAncient.params `
- `mergit -p ... ` es para correr mergeit con este fichero de parametros.

Mandar a correr el job con `sbatch 2_merge_AADR-Modern.sh`.

Mirar el estatus de la cola con `squeue -u <user> ` (su user es `cursojnab<N>`). Cuando no aparece mas es que se acabo la corrida.

Funcionó? Mirar los Logs (`Logs/merge.e` y `Logs/merge.o`) y verificar si se generaron los archivos esperados en `Outputs/`

Vemos que no le gusta que los alelos no sean consistentes entre los dos archivos. Eso se debe a que puede ser una posición tri-allelica pero eigensoft (y plink) solo reconocen posiciones bi-allelica.
Pero además cuando trabajamos con datos de genotipificación, existe el problema de la cadena: un A leido en la cadena + corresponde a un T en la cadena -. Lo mismo para C/G. Llamamos los genotipos A/T y C/G "ambiguos". Cuando trabajamos con datos de secuenciación, en general todo se lee con la cadena + y no hay ambiguidad, pero con datos de genotipificación, es más complicado (depende de la poisición y de la tecnología), entonces es recomendable sacar las posiciones con alelos A/T y C/G. Es lo que hace eigensoft.

Con `wc -l Outputs/ModernAncient.snp.txt ` se puede consultar cuantas posiciones quedaron.
Con ` awk '{print $5,$6}' Outputs/ModernAncient.snp.txt | sort | uniq ` se puede ver el conteo de las combinaciones Alelo1/Alelo2 de las variantes que quedan, y verificar que ya no hay genotipos ambiguos.
Con ` wc -l  Outputs/ModernAncient.ind.txt `  podemos ver el número de individuos (corroborar que corresponde con los inputs).


### 2.2. Modern + AADR + Outgroups
El script `3_merge_Outgoups.sh ` permite fusionar los datos que acabamos de generar con el archivo de "Outgroups".
Mandarlo a correr con `sbatch 3_merge_Outgoups.sh `
Es muy parecido al script previo. Mirarlo para tratar de entender los ficheros de entrada y de salida.

Los archivos estan al formato "binary" de plink y se constituyen de 3 archivos
- `<pref>.bim`: mapa de las variantes con 6 columnas chr | snpID | posicion (en cM) | posicion (en bp) | Alelo1 | Alelo2 (ver [https://www.cog-genomics.org/plink/1.9/formats#bim](https://www.cog-genomics.org/plink/1.9/formats#bim)
- `<pref>.fam`: informacion sobre los individuos FamilyID | IndID |  fatherID |  motherID | Sex | Phenotype (ver [https://www.cog-genomics.org/plink/1.9/formats#fam](https://www.cog-genomics.org/plink/1.9/formats#fam))
- `<pref>.bed`: matriz de genotipos (binario y no se puede leer directamente; ver [https://www.cog-genomics.org/plink/1.9/formats#bed](https://www.cog-genomics.org/plink/1.9/formats#bed)

Cuantas posiciones quedan?

Con `more Outputs/ModernAncienti_withOuthroups.fam `, vemos que la información poblacional se perdió. No nos estresmos, lo vasmos a arreglaremos.
En la terminal hacer: 
`Rscript RScripts/fixID.R  ` (correr un script R qui itera por los individuos y atribuye la poblacion (1a y 6ta columna del archivo Outputs/ModernAncienti_withOuthroups.fam) la asignada en los archivos iniales (3a columna de los archivos `.ind.txt`).

- Mirar el numero de individuos por poblacion: ` awk '{print $1}' Outputs/ModernAncient_withOutgroups.fam | sort | uniq -c `

## 3. Datos faltantes
Cuando trabajamos con datos enmascarados y datos de ADN antiguo, no podemos usar filtros estrictos sobre valores faltantes (por ejemplo en modernos sin enmascarar solemos sacar los individuos con mas de 5% de genotipos faltantes y los snps con mas de 2%). En nuestro caso, se trata de hacer un compromiso entre  trabajar con matrices de genotipos sin demasiados datos faltantes, pero al mismo tiempo poder analizar la mayor cantidad de individuos y variantes posibles. Vamos a explorar entonces las distribuciones de valores faltantes por individuo y por posicion.
Plink permite obtener estos datos directamente (ver [https://www.cog-genomics.org/plink/1.9/basic_stats#missing](https://www.cog-genomics.org/plink/1.9/basic_stats#missing)).

Vamos a correr `sbatch 4_getMissingDataStats.sh  ` para generar:
- `Outputs/ModernAncient_withOutgroups.imiss`: valores faltantes por individuo
- `Outputs/ModernAncient_withOutgroups.lmiss`: valores faltantes por snp
 
Corroborar que haya funcionado bien (mirar los Logs y si existen los Outputs esperados). Verificar que el numero de individuos es el esperado dados los ficheros de entrada. Cuantas variantes tiene el conjunto de datos generado?

Ahora vamos a resumir esta informacion en R (script RScripts/distributionMissing.R). Mirar el script para ver que hace. Pedir ayuda para interpretar si necesario.
Como tenemos que leer un archivo grande (Outputs/ModernAncient_withOutgroups.lmiss que tiene centenares de miles de lineas) y R es demandante tenemos que pdoemos pasar por un nodo de computacion y correr `sbatch 5_runRscriptForMissingDistributions.sh ` (mirarlo para entenderlo). Pero parece que trabajar directamente en el submit-node no es tan grave, entonces correr `Rscript RScripts/distributionMissing.R` para no pasar por la cola de submit.

Desafortunamente, no podemos ver el pdf que se genera directamente y hay que descargarlo en la computadora.
Desde la terminal de la computadora (no estando conectado a mulatona), hacer `scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia1/sesion3/Outputs/ModernAncient_withOutgroups_missing.pdf ~/ ' y abrir el pdf en su computadora.

Vemos que la tasa de valor faltante para los individuos modernos enmascarados es mucho mas alta que para los antiguos. Y vemos que la distribucion de la tasa de valores faltantes por variante es bi-modal. Esto suele pasar cuando la lista de variantes entre dos conjuntos de datos son distintas. Vamos a corroborar mirando mirando la tasa de valores faltantes por snp en sub-conjuntos de individuos.
En plink existe la opcion [`--keep ` para filtrar individuos](https://www.cog-genomics.org/plink/1.9/filter#indiv). 
Para usarla, hay que creo un archivo que contiene por los menos las columnas FamilyID | IndID. Este se puede generar facilmente con comandos de bash desde el fichero fam de partida, si conocemos bien los datos. Mirar en el script  `6_getMissingDataStats_perDataSet.sh` como se generan los dos archivos `ModernAncient_withOutgroups_onlyModernEnmascarados.KEEP` y `ModernAncient_withOutgroups_onlyAncient.KEEP` a traves de la funcion `grep`.
Correr `sbatch 6_getMissingDataStats_perDataSet.sh `. Miremos las distribuciones de los valores faltantes en cada sub-conjunto:
- Primero los datos modernos:` Rscript ModernAncient_withOutgroups_onlyModernEnmascarados`
- Luego los datos antiguos:` Rscript ModernAncient_withOutgroups_onlyAncient`
Copiar en la computadora estos archivos con comando scp:
- scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia1/sesion3/Outputs/ModernAncient_withOutgroups_onlyModernEnmascarados_missing.pdf ~/ 
- scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia1/sesion3/Outputs/ModernAncient_withOutgroups_onlyAncient_missing.pdf ~/

Vemos que para muchos SNPs, la tasa de faltante en los datos modernos enmascarados es de 1: es decir que las posiciones no estan representadas en estos datos. Es lo que hace eigensoft, no filtra por posiciones que se solapan entre dos conjuntos de datos, pero atribuye genotipo faltante para todos los individuos de un conjunto para las posiciones no presentes en este pero si en el otro conjunto.
Vemos que para los datos antiguos, no hay este problema. Para evitar de usar posiciones solo en un conjunto de datos (solo para antiguos), vamos a aplicar primero un filtro sobre valores faltantes por posicion, adaptando el umbral.
Tenemos 47+141+56=244 individuos. 141 son de los datos enmascarados. Si sacamos los snps con mas de 141/255 = ~ 0.55 estamos seguros de no tener mas estos SNPs. 
El preblema con plink es que si aplicamos el filtro para snp y individuo en el mismo comando, aplica siempre el filtro por individuo primero. Entonces tenemos que hacerlo secuencialmente.
- Vamos a usar la funcion [`--geno`](https://www.cog-genomics.org/plink/1.9/filter#missing) con un umbral de 0.5 (para ser conservador)).
- Luego filtraremos los individuos con una tasa de valores faltantes superior a 0.3 (con [`--mind`](https://www.cog-genomics.org/plink/1.9/filter#missing)).
- Luego filtraremos por Minor Allele Frequency (MAF) con un umbral de 0.01 (con [`--maf `](https://www.cog-genomics.org/plink/1.9/filter#maf)).
- Y finalmente guardaremos solo los [tag-snps](https://www.cancer.gov/espanol/publicaciones/diccionarios/diccionario-genetica/def/tagsnp) para tener variantes independientes (necesario para admixture que usaremos en la sesion 5). Los tag-snps se buscan con una aproximacion de ventanilla corredera de 50 snps, con un offset de 5, with r2>0.5 usando el parametro `--indep-pairwise 50 5 0.5`. Genera un archivoprune.in con los tag-snps, que podemos luego leer en plink con la funcion `--extract`.





 









 

