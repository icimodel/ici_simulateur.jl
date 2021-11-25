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

## Aperçu rapide du fonctionnement du simulateur : 

Parler des packages requis : LightGraphs, ... 

Données d'entrées (graphe au format ML) + modules de paramètres 

Pour en savoir plus, merci de se référer à la documentation présente ci-dessous. 

## Documentation

- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Project Status

The package is tested against, and being developed for, Julia `1.0` and above on Linux and macOS.

## Questions and Contributions

Contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems. The [contributing page][contrib-url] has a few guidelines that should be followed when opening pull requests and contributing code.

## Related packages

There are several packages that extend Documenter in different ways. The JuliaDocs organization maintains:

* [DocumenterTools.jl](https://github.com/JuliaDocs/DocumenterTools.jl)
* [DocumenterMarkdown.jl](https://github.com/JuliaDocs/DocumenterMarkdown.jl)

## Pour une utilisation sur un cluster de calcul 

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








```@meta
DocTestSetup  = quote
    using ICI_simulateur
end
```


## Example blocks

### Script: @example

```@example
import Random   # hide
Random.seed!(1) # hide
A = rand(3, 3)
b = [1, 2, 3]
A \ b
```

### REPL: @repl

```@repl
1 + 1
```

## Documentation tests

### Script

```jldoctest
a = 1
b = 2
a + b

# output

3
```

### REPL

```jldoctest
julia> a = 1
1

julia> b = 2;

julia> c = 3;  # comment

julia> a + b + c
6
```

## Reference

### @autodocs

```@autodocs
Modules = [ICI_simulateur]
Order   = [:function, :type]
```
