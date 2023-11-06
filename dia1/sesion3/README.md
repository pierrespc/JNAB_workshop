# Sesion 3: Manejo de datos

En esta sesion, vamos a usar comandos basicos para:
- explorar datos de genotipos
- fusionar datos
- filtrar por valores faltantes, Frecuencia del Alelo Menor (MAF), Desequilibrio de Ligamimiento (LD)

Vamos a trabajar desde 3 archivos al formato EIGENSOFT:
- Datos de genotipificacion de individuos modernos ( de la Fuente et al. 2018 y Luisi et al. 2020). Estos datos fueron enmascarados por individuo para quedarse solo con las regiones genomicas de ancestria genetica indigena (para cada individuo, los genotipos de las variantes en regiones con ancestria genetica no indigena fueron asignados a Valor Faltante).
- Datos de secuenciacion de individuos antiguos (de la Fuente et al. 2018, Nakatsuka et al. 2020, Raghavan et al. 2015).
- Datos de secuenciacion de individuos modernos de Francia (French), de Nigeria (Yoriba) y Congo (Mbuti).


## Explorar los ficheros
Vamos a ver a que se parecen los datos en el formato eigensoft.

En la terminal. Ubicar se en ${HOME}/JNAB/dia1/sesion3/:

` cd ${HOME}/JNAB/dia1/sesion3/ `

Los datos de genotipos en el formato eigensoft se conforman de 3 archivos (ver : [https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README](https://github.com/argriffing/eigensoft/blob/master/CONVERTF/README)) 
- `<pref>.snp.txt`: el mapa de las variantes con 6 columnas: snpID | chr | position (in cM) | position (in bp) | Allele1 | Allele2
- `<pref>.ind.txt`: informacion de los individuos con 3 columnas indID | Sex | Population
- `<pref>.geno.txt`: la matrix de genotipos (1 linea por individuo, una columna por variante; los individuos y las variantes estan en el mismo orden que en el .ind.txt y el .snp.txt). El genotipo esta codificado con el numero de copias del Alelo1 (0/1/2 y 9 para valor faltante).


