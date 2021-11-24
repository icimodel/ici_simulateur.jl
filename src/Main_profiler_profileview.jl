#!/usr/bin/env julia

using Pkg
using MPI
using ICI_simulateur: Parallelisation, City, Population, Simulateur, Save 
using Profile 
using ProfileView 


######################## Calcul du temps reel ##################################
deb = time() ;
################################################################################

####################### Initialisation de la parallélisation ###################
comm,rank = Parallelisation() ;
################################################################################

######################## Définition de la ville ################################
Ville = City() ;
################################################################################

################### Définition de la population ################################
Individu = Population() ;
################################################################################

############################### Simulateur #####################################
Propagation = Simulateur(Ville,Individu,rank) ;
################################################################################

########################### Partie des résultats ###############################
Save(Propagation,rank,comm) ;
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

