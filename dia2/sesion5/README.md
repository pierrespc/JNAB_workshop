# Sesión 5: Analisis de datos

En esta sesión, vamos a analizar los datos de Patagonia:
- en un contexto global con Admixture ([Alexander et al. 2008](https://genome.cshlp.org/content/19/9/1655) y ACP ([Patterson et al. 2006](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.0020190).
- en un contexto mas local con los estadisticos F ([Patterson et al. 2012](https://academic.oup.com/genetics/article/192/3/1065/5935193).


Los datos estan en StartingData y son los datos que generamos en la sesion 3:
- `StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.{bed,bim,fam} `: datos de Modernos y Antiguos, filtrados por valores faltantes (pero no MAF ni LD). Se usaran en el ACP
- `StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.{bed,bim,fam}`: datos de Modernos y Antiguos, filtrados por valores faltantes, MAF y LD. Se usaran para Admixture

Ubicarse en `${HOME}/JNAB/dia2/sesion5/` y generar las carpetas `Logs` y `Outputs`
`cd ${HOME}/JNAB/dia2/sesion5/
./0_init.sh `

Generar las carpetas Logs y Outpus
# ACP en un contexto Global

Vamos a usar `smartpca` de EIGENSOFT (ver [https://github.com/argriffing/eigensoft/tree/master/POPGEN](https://github.com/argriffing/eigensoft/tree/master/POPGEN).
El comando es simple: se llama smartpca con un archivo de parametro (opcion  -p) que contiene infirmacion sobre los datos de entrada, donde se generan las salidas y algunas opciones para el algoritmo.
Se calcula el ACP con los datos modernos (opcion poplistname) y se proyectan los datos antiguos. Esto se debe a (se suele hacer con ADN antiguo). Para eso tenemos que generar un archivo lista de las poblaciones modernas.
Tambien, como tenemos muchos valores faltantes en la matriz de genotipos de modernos, vamos a usar la opcion [lsqproject](https://github.com/DReichLab/EIG/blob/master/POPGEN/lsqproject.pdf) que permite tomar mejor en cuanta este problema al momento de construir los Componentes prinpales.
`smartpca` permite sacar individuos outliers. No los vamos a usar (para desabilitarlo ponemos 0 al parametro `numoutlieriter`).

Correr `sbatch 1_PCA.sh` y verificar que se generaron bien los ficheros en `Outputs/PCA`
- ficheros de los eigen vectors (`.evec`): una linea un individuo y una columna su posicion en un COmponente Principal (1a y ultima columna son datos de anotacion del individuo)
- ficheros de los eigen value (`.eval`): Varianza explica por el componente)

Vamos a graficar estos resultados para los 10 primeros componentes con `Rscript 2_plotPCA.R`.
Descargar el pdf de salida en la computadora con `scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia2/sesion5/Outputs/PCA/PCAwithProjection.pdf . `.
Que diversidad captura cada componente? Que conlusiones se pueden sacar del PC2 vs PC1? Del PC4? Del PC5?

# Admixture en un contexto Global

Vamos a usar Admixture (ver [https://dalexander.github.io/admixture/](https://dalexander.github.io/admixture/) con los datos filtrados para MAF y LD porque el modelo requiere de datos independientes.
Se fijan K poblaciones ancestrales a priori. Vamos a probar para K entre 3 y 10. Una manera de selecionar el modelo mas robusto segun los datos es seleccionando el modelo con el menor escore de [validacion cruzada](https://datascientest.com/es/cross-validation-definicion-e-importancia). 
Admixture se llama asi: `admixture <inputbed> K --seed <Num> --cv `. \\
Seed es una semilla aleatoria (o estado de semilla, o semilla) es un número utilizado para inicializar un generador de números pseudoaleatorios. Fijando la seed nos aseguramos que el resultado sera igual a cada repeticion. Pero si cambiamos las seeds, el resultado puede cambiar (en general llevemente). Volveremos sobre eso despues. \\
Con `--cv` decimos al programa que queremos estimar la validacion cruzada (cross-validation en ingles). Es una manera de selecionar el modelo mas robusto segun los datos es seleccionando el modelo con el menor escore de [validacion cruzada](https://datascientest.com/es/cross-validation-definicion-e-importancia).

Para que las diferentes corridas de Admixture (una corrida por cada K), vamos a evitar de hacer un script que corre todo secuencialmente, pero mejor que cada corrida sea un jpb indpendiente en el cluster.
Para eso correr `./3_Admixture.sh` (mirar como se manda cada job, es otra sintaxis alternativa a la que veniamos haciendo).

A mayor K (mas poblaciones ancestrales), mas complejo el modelo y mas tiempo de computacion. Entonces, vamos a ver como los jobs con K bajos acabaran antes que los jobs con K altos.

Podemos seguir el avance con los logs \\
(p.ej `less Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.K<K>.log `

Cuando se acabaron todas las corridas de admixture, vamos a recuperar los CV scores de cada una yvolcarlas en un unico archivo llamado `Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.CV.tsv \\`
Correr `./4_getCV.sh` y mirar el archivo creado. Que K seleccionaria segun el CV score? Ojo: no es el modelo mas valido para explicar sus datos y los modelos con mas o menos K pueden ser muy informativos. 
