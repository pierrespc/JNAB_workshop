# Sesion 3: Manejo de datos

En esta sesion, vamos a usar comandos basicos para:
- explorar datos de genotipos
- fusionar datos
- filtrar por valores faltantes, Frecuencia del Alelo Menor (MAF), Desequilibrio de Ligamimiento (LD)

## Explorar los ficheros
Vamos a ver a que se parecen los datos en el formato eigensoft.

Vamos a trabajar desde 3 archivos al formato EIGENSOFT:
- Datos de genotipificacion de individuos modernos ( de la Fuente et al. 2018 y Luisi et al. 2020). Estos datos fueron enmascarados por individuo para quedarse solo con las regiones genomicas de ancestria genetica indigena (para cada individuo, los genotipos de las variantes en regiones con ancestria genetica no indigena fueron asignados a Valor Faltante). En `StartingData/MaskedModernData/
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
- Obtener numero de variantes (numero de lineas en el archivo \<pref\>.snp.txt con `wc -l \<pref\>.snp.txt).
- Obtener numero de individuos (numero de lineas en el archivo \<pref>.ind.txt con `wc  -l \<pref\>.ind.txt).
- Obtener 
Con `head \<nombre del archivo\> ` mirar las 10 primeras lineas del mapa, de los individuos y de la matriz de genotipos.
- Cuales son los alelos de las 5 primeras variantes? (Se puede mostrar solamente las 5 primeras lineas con `head -5 \<pref>.snp.txt`)
- A que poblaciones pertenecen los 3 primeros individuos? (se puede mostrar solamente las 3 primeras lineas con `head -3 \<pref>.ind.txt`)
- Cual es el genotipo de lo 3 primeros individuos para las 5 primeras variantes? (se puede mostrar estos genotipos con `head - primer






 

