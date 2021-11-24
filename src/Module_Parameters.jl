module ParamSimu

    const NB_DAY = 80 ;  # nombre de jours simulés
    const NB_CONT = 5 ; # nombre initial de contaminés
    const NB_MC = 2 ; # nombre de simulations (methode Monte-Carlo)
    const vMPI = false ; # Si on utilise MPI 
    const CALCULATEUR = false ; # Calcul sur super-calculateur
    const SORTIE = false ; # Pas encore utilisé ? 
    const PRINT_ETAT = true ; # Pour afficher l'état de l'épidémie à chaque journée (peut devenir lourd si on est en MPI)

end

module ParamFile

    #const GRAPH_FILE = "SaintVicNoChildrenLeftBehind" ;
    const GRAPH_FILE = "outSaintVic_0.2.1.1"; # Nom du graphe contenant la population et les batiments 
    const vTXT = true ; # Si on veut une sortie du modèle en txt 
    const vJSON = true ; # Si on veut une sortie du modèle au format json 
    const CSV_PARAM = false ; # Si on veut ajouter les valeurs des paramètres d'entrée dans un CSV 
    const MEAN_MC = true ;
    const ALPHA = 0.95 ; 

end


module SortieModele

    const LIEUX_CONTAM = false ; # Sortie avec les lieux de contamination  
    const RES_STATUT = false ; # Sortie des indicateurs selon le statut des individus (écolier/étudiant/actif/retraite)
    const RES_FLUX = false ; # Sortie des indicateurs selon le flux (entrée/sortie)

end 


module ParametreCovid

    # Définition de la loi normale du temps d'incubation
    const MU_INCUB = 5 ;
    const SIGMA_INCUB = sqrt(2) ;
    # Définition de la loi normale du temps de contamination
    const MU_DT_CONT = 5 ;
    const SIGMA_DT_CONT = sqrt(2) ;
    # Définition du temps de départ de la contamination
    const MU_DEB = 1 ;
    const SIGMA_DEB = 2 ;
    # Paramètre de contamination
    const MU_PROB = 0.15 ;
    const SIGMA_PROB = 0.005 ;
    # Taux d'asymptomatique
    const TAUX_ASYMP = 0.3 ;
    # Asymptomatique selon l'age 
    const ASYMP_AGE = false ; 
    # Taux d'asymptomatique selon la classe d'âge 
    const ASYMP_AGE_VALUES = [0.5,0.5,0.5,0.5,0.3,0.3,0.3,0.3,0.2,0.2] ; 
    # Pénalité sur la proba de transmission 
    const PENALITE = false ; 
    # Si on veut fixer les premières contaminations sur un statut social précis 
    const CONT_TO_STATUT = false ; 
    # Quelle statut ?
    const STAT_CONT_TO = 1 ; 

end


module ParamPop

    # Nombre d'individus sortant du quartier (ailleurs en journée)
    const NB_OUT = 1000 ;
    # Nombre d'individus entrant dans le quartier (viennent travailler)
    const NB_IN = 35000 ;
    # Taux d'étudiant parmis les entrant
    const TAUX_ETUD = 0.8 ;
    # Nombre d'écolier par classe
    const NBPERCLASS = 30 ;
    # Nombre d'étudiant par amphithéâtre
    const NBPERAMPHI = 40 ;
    # Paramètre de la loi de Poisson caractérisant le tissu social au sein des structures
    const LAMBDA_TISSU = 5 ;
    # Nombre de m2 par employés
    const M2_EMPLOY = 20 ;

end


module JourneeType

    const Ecolier = [1,2,2,2,2,1,1] ;
    const Etudiant = [1,2,2,2,3,3,1]  ;
    const Actif = [1,2,3,2,3,3,1] ;
    const Retraite = [1,3,1,3,3,1,1] ;

end


module DistanceC

    const MIN_TISSU = 1 ;
    const MAX_TISSU = 3 ;
    const MIN_HTISSU = 5 ;
    const MAX_HTISSU = 50 ;
    const MIN_MENAGE = 1 ;
    const MAX_MENAGE = 5 ;
    const MIN_RESTO = 0.5 ;
    const MAX_RESTO = 6 ;

end

module TempsC

    const MIN_TISSU = 1 ;
    const MAX_TISSU = 3 ;
    const MIN_HTISSU = 5 ;
    const MAX_HTISSU = 50 ;
    const MIN_MENAGE = 1 ;
    const MAX_MENAGE = 5 ;
    const MIN_RESTO = 0.5 ;
    const MAX_RESTO = 6 ;

end




module Journee

    const CHOIX_ALEATOIRE_RESTO = true ; 
    const EGT_DATA = false ; 

    module Semaine
        
        const min_dep = [7,7,7,9] ;
        const max_dep = [9,9,9,11] ;
        const min_arr = [16,16,16,15] ;
        const max_arr = [18,18,18,17] ;
        const TYPE = [[1,2,3,2,4,5,1] [1,2,3,2,2,1,1] [1,2,3,2,1,1,1] [1,4,4,4,1,1,1]] ;
        const Deb_Type = [0,8,12,14,17,18,21] ;
        const Fin_Type = [8,12,14,17,18,21,24] ;

    end

    module Proba

        const sortieJournee = [1,1,1,0.7] ;
        const RESTO = [0.7,0.2,0,0] ; # Probabilité d'aller au restaurant suivant le statut des individus 
        const sortieSoir = [0.2,0.3,0,0] ;
        const SORTIECOURSES = [0.3,0.3,0,0] ; # Probabilité d'aller faire des courses suivant le statut des individus 
    end

    module WeekEnd

        const Type = [[1,2,3,2,3,3,1] [1,2,3,2,3,3,1] [1,2,2,2,2,1,1] [1,2,2,2,1,1,1]] ;

    end



end


module ParamPOI
    module temps
        const tps_min_resto = 0.5 ;
        const tps_max_resto = 2 ;
        const tps_min_courses = 0.1 ;
        const tps_max_courses = 0.9 ;
        const tps_min_loisirs = 1.5 ;
        const tps_max_loisirs = 3 ;
    end
end


module DefPOI

    module Resto
        const Type = ["commerce_alimentation", "loisir.restauration"] ;
    end

    module EcolePrimaire
        const Type = ["education.primaire"] ;
    end

    module CollegeLycee
        const Type = ["education.secondaire"] ;
    end

    module Universite
        const Type = ["education.superieure"]
    end

    module Loisir
        const Type = ["loisir.restauration", "loisir.activiteCulturo-sportif", "loisir.sortie"] ;
     end

     module Ecole
        const Type = ["education.primaire", "education.secondaire","education.particuliere","education.superieure"]
     end

end


module ParamSIR 

    const NB_DT = 80 ; 

end 

module ParamSEIR 

    const NB_DT = 80 ; 

end 




#module PostTraitement

#    const CalculRO = 1 ;

#end
