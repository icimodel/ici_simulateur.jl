############# Définir les différentes mesures applicables ######################

module mesures
    # Pas d'intervention
    const INTERVENTION = true ;
    # Tracabilité
    const TRACAGE = true ;
    # Distanciation sociale
    const DISTANCE = false ;
    # Port du masque
    const MASQUE = false ;
    # Confinement
    const CONFINEMENT = false ;
    # Vaccination
    const VACCIN = false ;
    # Tele-travail
    const TELETRAVAIL = false ;
    # Fermeture
    const FERMETURE = false ;
    # Cas contact
    const CAS_CONTACT = false ;
end



################################################################################


############################## Tracabilite #####################################

# Module contenant les paramètres liés à la tracabilité

module Trace
    # Seuil d'alerte (nombre de nouvelles contamination)
    const SEUIL_INCIDENCE = 90 ;
    # Délai, en jours, pour isoler l'individu contaminé
    const DELAI_TRACE = 2 ;
    # % de personnes testés
    const TAUX_TEST = 0.5 ;
    # Nombre de jours confinés
    const JOURS_CONF = 14 ;
end

################################################################################


############################ Distanciation #####################################

# Module contenant les paramètres liés à la distanciation sociale

module Distanciation
    # Augmentation de la distance moyenne entre deux individus, exprimée en m
    const DISTANCE_SUP = 2 ;

end

################################################################################

############################ Port du masque ####################################

# Module contenant les paramètres liés au port du masque

module PortMasque
    # Augmentation de la distance moyenne entre deux individus, exprimée en m
    const DISTANCE_SUP = 2 ;

end

################################################################################

############################## Confinement #####################################

# Module contenant les paramètres liés au confinement

module Confinement
    # Seuil d'alerte
    const SEUIL_INCIDENCE = 300 ;
    # Durée du confinement, exprimée en jours
    const DUREE = 40 ;
    # Teletravail
    const TELETRAVAIL = true ;
    # Taux de télétravail (actif)
    const TAUX_TELE = 0.2 ;
    # fermeture commerce non-essentiel
    const POI_NE = true ;
    # fermeture ecole
    const FERMETURE_ECOLE = true ;
end

################################################################################


####################### Fermeture des écoles ###################################

# Module contenant les paramètres liés à la fermeture des écoles

module Fermeture
    # Seuil d'alerte
    const SEUIL_ALERTE = 100 ;
    # Ecoles
    const ECOLES = true ;
    # POI non-essentiel
    const POI_NE = true ;
    # POI essentiel
    const POI_E = false ;
end

################################################################################


####################### Fermeture des écoles ###################################

# Module contenant les paramètres liés au télé-travail

module Teletravail
    # Seuil d'alerte
    const SEUIL_ALERTE = 100 ;
    # taux d'actif en télé-travail (par entreprise ?)
    const TAUX_TELE = 0.9 ;
end

################################################################################




########################## Calcul des indicateurs ##############################

function Calcul_R0(nb_transmi,nb_contact_cont)

    #fin = length(nb_transmi) ;
    d = Dict([(i,count(x->x.==i,nb_contact_cont)) for i in unique(nb_contact_cont)]) ;
    dv = collect(keys(d)) ;

    R0_local = zeros(Int32,length(dv)) ;

    for i=1:length(dv)

        Ind = findall(nb_contact_cont .== dv[i]) ;
        R0_local[i] = sum(nb_transmi[Ind]) ;

    end

    return(R0_local) ;

end


#function Calcul_Reff()
#end


################################################################################



######################## Prise en compte des mesures ###########################

function MiseEnPlaceMesure(Ncontam)

    if(scenario == 0) # Si pas de mesures
        Indice_mesure = 0 ;
    else # Si on a mis en place une mesure au debut de la simulation
        if(Ncontam > 1000) # si on a plus de 1000 personnes contaminées, alors
            Indice_mesure = 1 ;
        end

    end

    return(Indice_mesure)

end


function RetourNormal(cpt)

    if(scenario == 4)
        cpt = cpt - 1 ;
    end

end



################################################################################
