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

Correr `sbatch 1_PCA.sh`

