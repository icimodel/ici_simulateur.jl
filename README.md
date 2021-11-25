# ICI modeling

*Un simulateur de propagation d'une épidémie au sein d'une population synthétique en Julia.*

| **Documentation**                                                               | **Build Status**                                                                                |
|:----------------------------------------------------------------------:|:-----------------------------------------------------------------------:|
| [![][docs-dev-img]][docs-dev-url] | [![][codecov-img]][codecov-url] |


# Comment faire fonctionner le simulateur 

## Pré-requis 
Tout d'abord, il faut télécharger Julia. Le simulateur a été testé sur la version 1.6.1. 
Ensuite, il faut télécharger ce projet github et se placer à l'intérieur de celui-ci. 

## Installation du simulateur 

En Julia, il existe deux façons de lancer des calculs. 

### A partir du REPL Julia 

1/ A partir du REPL Julia : Dans un terminal Linux ou MacOS, tapez : 
```
> julia --project=.
```
L'option `project` permet d'initialiser l'environnement dans lequel tourne le simulateur.
Une fois que Julia est lancé :
```julia
julia> using Pkg; using ICI_simulateur ; 
```
Le simulateur nécessitant de lire les données d'entrées et d'effectuer des sorties, 
il convient de se placer dans le dossier source. Pour se faire : 
```julia
julia> cd("src/")
```
A savoir qu'il est également possible de passer par un shell en utilisant la commande suivante : 
```julia
julia>;
shell> cd src/
```
Une fois cette tâche effectuée, nous pouvons lancer les simulations en appelant la fonction `Principal` : 
```julia 
julia> Principal() ; 
```

### A partir d'un shell  
A partir d'un shell, il est également possible de lancer un script Julia. Pour lancer les simulations, 
il faut créer un script regroupant les commandes taper plus haut et enregistrer cela dans un fichier script.jl 
au sein du dossier ici_simulateur.jl/.
Pour lancer les simulations : 
```
> julia --project=. script.jl
```

## Cluster or not cluster ? 

Le simulateur ICI fonctionne aussi bien en séquentiel (un seul processus) qu'en parallèle (plusieurs processus) en local
ou sur des grands clusters de calculs. 
Cependant, l'utilisateur doit bien indiquer son choix dans le module `ParamSimu` présent dans le fichier 
`Module_Paramters.jl` avant de lancer les simulations. 
### Sur un ordinateur local avec un seul processus (séquentiel)

```julia 
module ParamSimu

    const NB_DAY = 80 ;  # nombre de jours simulés
    const NB_CONT = 5 ; # nombre initial de contaminés
    const NB_MC = 2 ; # nombre de simulations (methode Monte-Carlo)
    const vMPI = false ; # Si on utilise MPI 
    const CALCULATEUR = false ; # Calcul sur super-calculateur
    const SORTIE = false ; # Pas encore utilisé ? 
    const PRINT_ETAT = true ; # Pour afficher l'état de l'épidémie à chaque journée (peut devenir lourd si on est en MPI)

end
```

Le lancement s'effectue comme indiqué plus haut. 

### Sur un ordinateur local avec plusieurs processus 

```julia 
module ParamSimu

    const NB_DAY = 80 ;  # nombre de jours simulés
    const NB_CONT = 5 ; # nombre initial de contaminés
    const NB_MC = 2 ; # nombre de simulations (methode Monte-Carlo)
    const vMPI = true ; # Si on utilise MPI 
    const CALCULATEUR = false ; # Calcul sur super-calculateur
    const SORTIE = false ; # Pas encore utilisé ? 
    const PRINT_ETAT = true ; # Pour afficher l'état de l'épidémie à chaque journée (peut devenir lourd si on est en MPI)

end
```

Pour faire tourner le code en parallèle, il est nécessaire de posséder 
une version de OpenMPI installée sur l'ordinateur. 


### Sur un cluster de calculs avec plusieurs processus 

```julia 
module ParamSimu

    const NB_DAY = 80 ;  # nombre de jours simulés
    const NB_CONT = 5 ; # nombre initial de contaminés
    const NB_MC = 2 ; # nombre de simulations (methode Monte-Carlo)
    const vMPI = true ; # Si on utilise MPI 
    const CALCULATEUR = true ; # Calcul sur super-calculateur
    const SORTIE = false ; # Pas encore utilisé ? 
    const PRINT_ETAT = false ; # Pour afficher l'état de l'épidémie à chaque journée (peut devenir lourd si on est en MPI)

end
```

Utiliser un script de soumission (à faire). 

## Aperçu rapide du fonctionnement du simulateur : 

### L'environnemet Julia avec ses packages 
Parler des packages requis : LightGraphs, ... 
* [CSV.jl](https://github.com/JuliaDocs/DocumenterTools.jl)
* [DataFrames.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [Distributions.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [Documenter.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [GraphIO.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [GraphMLReader.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [JSON.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [LightGraphs.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [MPI.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [MetaGraphs.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [SpecialFunctions.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [StatsBase.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [Dates.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [DelimitedFiles.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [Random.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)
* [Statistics.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)

### Les données d'entrées 

Les données d'entrées sont situés dans le dossier `src/data`. 
Les paramètres d'entrées du modèle sont présents dans `src/` dans le module `Module_Parameters.jl`

### Les données de sorties 
Données de sorties 


Pour en savoir plus sur le code, merci de se référer à la documentation présente ci-dessous. 

## Documentation

- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Project Status

The package is tested against, and being developed for, Julia `1.0` and above on Linux and macOS.

## Questions and Contributions

Contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems. The [contributing page][contrib-url] has a few guidelines that should be followed when opening pull requests and contributing code.






[contrib-url]: https://juliadocs.github.io/Documenter.jl/dev/contributing/
[discourse-tag-url]: https://discourse.julialang.org/tags/documenter
[gitter-url]: https://gitter.im/juliadocs/users

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://icimodel.github.io/ici_simulateur.jl/


[travis-img]: https://travis-ci.org/JuliaDocs/Documenter.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaDocs/Documenter.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/xx7nimfpnl1r4gx0?svg=true
[appveyor-url]: https://ci.appveyor.com/project/JuliaDocs/documenter-jl

[codecov-img]: https://codecov.io/gh/JuliaDocs/Documenter.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaDocs/Documenter.jl


## Reference
