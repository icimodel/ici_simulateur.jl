#!/usr/bin/env julia

using Pkg
using MPI
using ICI_simulateur: Parallelisation, City, Population, Simulateur, Save 
using TimerOutputs

const to = TimerOutput() ;

######################## Calcul du temps reel ##################################
deb = time() ;
################################################################################

####################### Initialisation de la parallélisation ###################
@timeit to "Parallelisation" comm,rank = Parallelisation() ;
################################################################################

######################## Définition de la ville ################################
@timeit to "City" Ville = City() ;
################################################################################

################### Définition de la population ################################
@timeit to "Population" Individu = Population() ;
################################################################################

############################### Simulateur #####################################
@timeit to "Simulateur" Propagation = Simulateur(Ville,Individu,rank) ;
################################################################################

########################### Partie des résultats ###############################
@timeit to "Save" Save(Propagation,rank,comm) ;
################################################################################

if(ICI_simulateur.ParamSimu.MPI)
    MPI.Barrier(comm) ;
end

if(rank == 0)
    elapsed = time() - deb ;
    println("Temps reel : ", elapsed, " secondes.") ;
end

if(ICI_simulateur.ParamSimu.MPI)
    MPI.Finalize() ;
end

print_timer(to)
