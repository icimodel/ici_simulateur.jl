#!/usr/bin/env julia

"""
Simulateur de propagation d'épidémies 
"""

module ICI_simulateur

    ###################### Importation des librairies ##########################
    using Statistics
    using Random
    using Distributions
    using DelimitedFiles
    using SpecialFunctions
    using MetaGraphs
    using LightGraphs
    using GraphMLReader
    using JSON
    using MPI
    using GraphIO
    using Dates
    using CSV
    using DataFrames
    using StatsBase
    ############################################################################

    ################# Include all functions and modules ########################
    include("Module_Parameters.jl")
    include("Module_Mesures.jl")
    include("functions_pretraitement.jl")
    include("struct_city.jl")
    include("struct_population.jl")
    include("struct_indicateur.jl")
    include("functions_deplacements.jl")
    include("struct_covid.jl")
    include("struct_simulateur.jl")
    include("functions_posttraitement.jl")
    ############################################################################

    export Principal 
    """
    Function Principal 
    Fonction principale du simulateur. Permet de lancer les simulations de propagation d'épidémies sur une région donnée. 
    C'est cette fonction qu'il faut appeler dans le programme principal
    """
    function Principal()

        deb = time() ;
        ############ Initialisation de la parallélisation ###################
        comm,rank = parallelisation() ;
        #####################################################################

        ############### Définition de la ville ##############################
        Ville = City() ;
        #####################################################################

        ############# Définition de la population ###########################
        Individu = Population() ;
        #####################################################################

        ########################## Simulateur ###############################
        Propagation = Simulateur(Ville,Individu,rank) ;
        #####################################################################

        ################## Partie des résultats #############################
        save(Propagation,rank,comm) ;
        #####################################################################

        if(ParamSimu.vMPI)
            MPI.Barrier(comm) ;
        end

        if(rank == 0)
            elapsed = time() - deb ;
            println("Temps reel : ", elapsed, " secondes.") ;
        end

        if(ParamSimu.vMPI)
            MPI.Finalize() ;
        end

    end
end 
