using TimerOutputs
using StatsBase

abstract type MyAbstractCovid end


export Statut_Covid
"""
mutable struct Statut_Covid
#Structure contenant les paramètres épidémiologiques du modèle
"""
mutable struct Statut_covid <: MyAbstractCovid

    # Vecteur contenant l'information sur l'état épidémiologique de chaque individu (0: sain, 1: contaminé, 2: contaminant, 3: guéri)
    contamination::Array{Int32,1}
    # Vecteur contenant l'information du temps d'incubation de chaque individu (exprimé en jour)
    incubation::Array{Int32,1}
    # Vecteur contenant l'information du début de la contamination de chaque individu (exprimé en jour depuis le temps d'incubation)
    deb_cont::Array{Int32,1}
    # Vecteur contenant l'information de la durée de contamination de chaque individu (exprimé en jour)
    duree_cont::Array{Int32,1}
    # Vecteur contenant l'information de la probabilité de transmission de chaque individu
    proba_trans::Array{Float64,1}
    # Vecteur contenant l'information de la présence de symptome (1: oui, 0: asymptomatique)
    symptome::Array{Int32,1}
    # Vecteur contenant l'information sur le nombre de jours de confinement pour chaque individu (si confinement global, tout le monde aura le même nombre)
    jours_conf::Array{Int32,1}
    # Vecteur contenant l'information sur le début de la mesure (si tracage, fin du temps d'incubation et début des symptomes)
    deb_mesure::Array{Int32,1}
    # Vecteur contenant l'information sur le fait de télé-travailler
    tele_travail::Array{Int32,1}
    # Booléen permettant de savoir si la mesure sanitaire est appliquée
    mesure_on::Bool

    function Statut_covid(Individu::Population)

        contamination = zeros(Int32,Individu.nb_pop) ;
        incubation = zeros(Int32,Individu.nb_pop) ;
        deb_cont = zeros(Int32,Individu.nb_pop) ;
        duree_cont = zeros(Int32,Individu.nb_pop) ;
        proba_trans = zeros(Float64,Individu.nb_pop) ;
        symptome = zeros(Int32,Individu.nb_pop) ;
        jours_conf = zeros(Int32,Individu.nb_pop) ;
        deb_mesure = -ones(Int32,Individu.nb_pop) ;
        tele_travail = zeros(Int32,Individu.nb_pop) ;
        mesure_on = false ;

        # On initialise les n_cont premières contaminations. Peut dépendre du statut social !
        if(ParametreCovid.CONT_TO_STATUT)
            Ind = findall(Individu.statut .== ParametreCovid.STAT_CONT_TO) ;
            Inds = StatsBase.randperm(length(Ind))[1:ParamSimu.NB_CONT] ;
            Ind = Ind[Inds] ;
        else
            Ind = StatsBase.randperm(Individu.nb_pop)[1:ParamSimu.NB_CONT] ;
        end

        # On met à jour l'état des premières contaminations (les individus sont déjà contaminants !)
        contamination[Ind] .= 2 ;
        deb_cont[Ind] .= 0 ;

        # Pour chaque individu
        @inbounds for i=1:Individu.nb_pop
            # On calcule les paramètres covid propre à l'individu
            incubation[i], deb_cont[i], duree_cont[i], proba_trans[i] = covid_identite() ;

            # On regarde si la personne est symptomatique/asymptomatique
            if(ParametreCovid.ASYMP_AGE)
                if(rand(Float64)>ParametreCovid.ASYMP_AGE_VALUES[Individu.cat_age[i]])
                    symptome[i] = 1 ;
                end
            else
                if(rand(Float64)>ParametreCovid.TAUX_ASYMP)
                    symptome[i] = 1 ;
                end
            end

            # On regarde si la personne active peut télétravailler suivant les
            if(mesures.INTERVENTION)

                if((mesures.TELETRAVAIL) & (Individu.statut[i] == 1))
                    if(rand(Float64)<Teletravail.TAUX_TELE)
                        tele_travail[i] = 1 ;
                    end
                end
                if((mesures.CONFINEMENT) & (Individu.statut[i] == 1))
                    if(rand(Float64)<Confinement.TAUX_TELE)
                        tele_travail[i] = 1 ;
                    end
                end

            end

        end

        # On initialise le nombre de jours de confinement (global ou individualisé)
        if(mesures.INTERVENTION)
            if(mesures.CONFINEMENT)
                jours_conf .= Confinement.DUREE ;
            end

            #if(mesures.TRACAGE)
            #    jours_conf .= Trace.JOURS_CONF;
            #end

        end

        return new(contamination,incubation,deb_cont,duree_cont,proba_trans,symptome,jours_conf,deb_mesure,tele_travail,mesure_on)

    end


end


abstract type MyAbstractDay end

export DefJournee
"""
Struct DefJournee
#Structure contenant les informations des déplacements des individus (identifiant du lieu, heure d'arrivée et heure de départ)
"""
struct DefJournee <: MyAbstractDay

    # Identifiant du lieu (POI, workingPlace)
    id_lieu::Array{Int32,2}
    # Vecteur des heures d'arrivée dans le lieu
    heure_arr::Array{Float64,2}
    # Vecteur des heures de départ dans le lieu
    heure_dep::Array{Float64,2}

    function DefJournee(nb_pop::Int32,nb_step::Int64)

        id_lieu = zeros(Int32, (nb_pop,nb_step)) ;
        heure_arr = zeros(Float64, (nb_pop,nb_step)) ;
        heure_dep = zeros(Float64, (nb_pop,nb_step)) ;

        return new(id_lieu,heure_arr,heure_dep)

    end

end

"""
Covid_Identite()

    # Function used to define the parameters associated to the Covid for each individual
    # Input:
    # NO INPUT
    # Output:
    # - tps_incub ({Int32}): incubation time (expressed in day)
    # - tps_dt_cont ({Int32}):
    # - proba ({Float64}): probability of contamination (between 0 and 1)

"""
function covid_identite()

    # Définition du temps d'incubation
    tps_incub = maximum([0,floor(Int32,rand(Normal(ParametreCovid.MU_INCUB,ParametreCovid.SIGMA_INCUB)))]) ;
    # Définition du temps de contamination
    duree_cont = maximum([0,floor(Int32,rand(Normal(ParametreCovid.MU_DT_CONT,ParametreCovid.SIGMA_DT_CONT)))]) ;
    # Définition du début de la contamination par rapport à la fin de l'incubation
    tps_deb = maximum([0,floor(Int32,rand(Normal(ParametreCovid.MU_DEB,ParametreCovid.SIGMA_DEB)))]) ;
    # Définition de la probabilité de contamination
    proba = abs(rand(Normal(ParametreCovid.MU_PROB,ParametreCovid.SIGMA_PROB))) ;

    deb_cont = tps_incub + tps_deb;

    return(tps_incub,deb_cont,duree_cont,proba)

end


export contamination_fct!
"""
Fonction Contamination_fct!
#Fonction calculant la contamination au sein du quartier
"""
function contamination_fct!(statcovid::Statut_covid,whereis_local::Array{Int32,1},iday::Int,Jour::DefJournee,tissu_work::Array{Int32,1},statut::Array{Int32,1})

    # Initialisation des vecteurs
    nb_step = size(Jour.id_lieu,2) ;
    Ind_cont = findall((statcovid.contamination .== 2)) ;
    nb_cont = size(Ind_cont,1) ;
    vie_malade = copy(Jour.id_lieu[Ind_cont,:]) ;
    statut_malade = statut[Ind_cont] ;

    # Pour chaque personne contaminée
    @inbounds for i=1:nb_cont
        # Pour chaque période de la journée
        @inbounds for j=1:nb_step
            Ind_pos = findall((Jour.id_lieu[:,j] .== vie_malade[i,j]) .& (statcovid.contamination .== 0) .& (vie_malade[i,j] .!= -1)) ;
            # On regarde s'il y a des personnes saines au même endroit que la personne contaminée
            if size(Ind_pos,1)>0
                # Pour chaque personne saine
                @inbounds for k=1:size(Ind_pos,1)
                    p = contamination_direct(Jour.heure_dep[Ind_cont[i],j],Jour.heure_dep[Ind_pos[k],j],Jour.heure_arr[Ind_cont[i],j],Jour.heure_arr[Ind_pos[k],j],statcovid.proba_trans[Ind_cont[i]],statut_malade[i],j,tissu_work[Ind_pos[k]],tissu_work[Ind_cont[i]]) ;
                    # Si la probabilité de contamination est plus forte que le rand, alors la personne saine devient contaminée
                    if(rand(Float64)<p)
                        statcovid.contamination[Ind_pos[k]] = 1 ;
                        push!(whereis_local,vie_malade[i,j]) ;
                    end
                end
            end
        end
    end

    return()

end


function contamination_fct_v2!(statcovid::Statut_covid,whereis_local::Array{Int32,1},iday::Int,Jour::DefJournee,tissu_work::Array{Int32,1},statut::Array{Int32,1})

    # Initialisation des vecteurs
    nb_step = size(Jour.id_lieu,2) ;
    Ind_cont = findall(statcovid.contamination .== 2) ;
    Ind_pos0 = findall(statcovid.contamination .== 0) ;
    nb_cont = size(Ind_cont,1) ;
    vie_malade = copy(Jour.id_lieu[Ind_cont,:]) ;
    statut_malade = statut[Ind_cont] ;

    # Pour chaque personne contaminée
    @inbounds @simd for i=1:nb_cont
        # Pour chaque période de la journée
        @inbounds for j=1:nb_step
            Ind_pos = findall((Jour.id_lieu[:,j] .== vie_malade[i,j]) .& (statcovid.contamination .== 0) .& (vie_malade[i,j] .!= -1)) ;
            # On regarde s'il y a des personnes saines au même endroit que la personne contaminée
            if size(Ind_pos,1)>0
                # Pour chaque personne saine
                @inbounds for k=1:size(Ind_pos,1)
                    p = contamination_direct(Jour.heure_dep[Ind_cont[i],j],Jour.heure_dep[Ind_pos[k],j],Jour.heure_arr[Ind_cont[i],j],Jour.heure_arr[Ind_pos[k],j],statcovid.proba_trans[Ind_cont[i]],statut_malade[i],j,tissu_work[Ind_pos[k]],tissu_work[Ind_cont[i]]) ;
                    # Si la probabilité de contamination est plus forte que le rand, alors la personne saine devient contaminée
                    if(rand(Float64)<p)
                        statcovid.contamination[Ind_pos[k]] = 1 ;
                        push!(whereis_local,vie_malade[i,j]) ;
                    end
                end
            end
        end
    end

    return()

end

export contamination_direct

"""
ContaminationDirect(depc,deps,arrc,arrs,proba)

    # Function used to compute the contamination
    # Input:
    # - depc:
    # - deps:
    # - arrc:
    # - arrs:
    # - proba:
    # Output:
    # - p

"""
function contamination_direct(depc::Float64,deps::Float64,arrc::Float64,arrs::Float64,proba::Float64,statut_malade::Int32,step_journee::Int64,tissu_pos::Int32,tissu_cont::Int32)

    if(statut_malade != 2)
        stat = JourneeType.Actif[step_journee] ;
    else
        stat = JourneeType.Retraite[step_journee] ;
    end

    duree = min(arrc,arrs) - max(depc,deps) ;

    if((mesures.DISTANCE == true) || (mesures.MASQUE == true))
        d = Distanciation.DISTANCE_SUP ;
    else
        d = 0 ;
    end


    if(stat == 2)
        if(tissu_pos == tissu_cont)
            distance = rand(Uniform(DistanceC.MIN_TISSU,DistanceC.MAX_TISSU)) + d ;
        else
            distance = rand(Uniform(DistanceC.MIN_HTISSU,DistanceC.MAX_HTISSU)) + d ;
        end
    elseif(stat == 1)
        distance = rand(Uniform(DistanceC.MIN_MENAGE,DistanceC.MAX_MENAGE)) + d;
    else
        distance = rand(Uniform(DistanceC.MIN_RESTO,DistanceC.MAX_RESTO)) + d ;
    end

    p = 1 - (1 - proba/distance^2)^duree ;

    if(ParametreCovid.PENALITE)
        p = 0.2*p ;
    end

    return(p) ;

end

export contamination_externe!
"""
Function Contamination_externe!
#Fonction permettant de calculer la contamination ayant lieu à l'extérieur du domaine
#Entrées :
#- statcovid::Statut_covid,
#- incidence::Array{Float64,1}
#- statut::Array{Int32,1}
#- indiv_in_out::Array{Int32,1}
#- whereis_local::Array{Any,1}
#Sorties :

"""
function contamination_externe!(statcovid::Statut_covid,incidence::Array{Float64,1},statut::Array{Int32,1},indiv_in_out::Array{Int32,1})

    # Contamination des gens qui vont travailler et manger hors 5ème
    # => contamination en entreprise et au poi
    # Contamination à l'école
    indiv_out = findall(indiv_in_out .==1) ;
    indiv_in = findall(indiv_in_out .<0) ;
    nbout = length(indiv_out) ;
    nbin = length(indiv_in) ;

    @inbounds for i=1:nbout
        if((statut[indiv_out[i]] .== 2) ||  (statut[indiv_out[i]] .== 3))
            r = rand(Binomial(1,incidence[1])) ;
            if((r==1) .& (statcovid.contamination[indiv_out[i]] .==0))
                statcovid.contamination[indiv_out[i]] = 1 ;
            end
        end

        if(statut[indiv_out[i]] .== 1)
            r = rand(Binomial(1,incidence[3])) ;
            if((r==1) .& (statcovid.contamination[indiv_out[i]] .==0))
                statcovid.contamination[indiv_out[i]] = 1 ;
            end
        end
    end

    # Contamination des gens qui vont travailler et manger dans le 5ème (indiv_in_out = -1)
    # => contamination chez eux

    @inbounds for i = 1:nbin
        r = rand(Binomial(1,incidence[4])) ;
        if((r==1) .& (statcovid.contamination[indiv_in[i]] .==0))
            statcovid.contamination[indiv_in[i]] = 1 ;
        end
    end


    return() ;


end


export statslieu_contamination

function statslieu_contamination(whereis_local::Array{Int32,1},Ville::City,Individu::Population)

    #d = Dict([(i,count(x->x.==i,whereis_local)) for i in unique(whereis_local)]) ;
    #dr = collect(keys(d)) ;
    #dv = collect(values(d)) ;

    nbetud = length(findall((Individu.statut .==2) .& (Individu.indiv_in_out .<=0))) ;
    nbetud = nbetud + length(findall((Individu.statut .==3) .& (Individu.indiv_in_out .<=0))) ;
    nbperspoi = length(findall(Individu.indiv_in_out .<=0)) ;
    nbwork = length(findall((Individu.statut .==1) .& (Individu.indiv_in_out .<=0))) ;
    nbhouse = length(findall(Individu.indiv_in_out .>=0)) ;

    iecole = 0 ;
    ipoi = 0 ;
    iwork = 0 ;
    ihouse = 0 ;

    @inbounds for i=1:length(whereis_local)

        cp = findall(Ville.id_poi .== whereis_local[i]) ;
        if(length(cp)>0)
            ipoi = ipoi + 1 ;
        end

        cw = findall(Individu.id_ind_work .== whereis_local[i]) ;
        if(length(cw)>0)
            if(whereis_local[i] >= 300000)
                iecole = iecole + 1 ;
            else
                iwork = iwork + 1 ;
            end
        end

        ch = findall(Individu.id_house .== whereis_local[i]) ;
        if(length(ch)>0)
            ihouse = ihouse + 1 ;
        end

    end

    res = [iecole/nbetud,ipoi/nbperspoi,iwork/nbwork,ihouse/nbhouse] ;

    return(res)

end

export mise_a_jour!
"""
mise_a_jour!(contamination0,contamination1,p_covid,cpt)

    # Function used to update the contamination at the end of the day
    # Input:
    # - contamination0:
    # - contamination1:
    # - p_covid:
    # - cpt:
    # Output :
    # - NO OUTPUT

"""
function mise_a_jour!(statcovid::Statut_covid,contamination0::Array{Int32,1})

    # Pour les gens contaminés, on met à jour le temps d'incubation
    IndCont = findall((contamination0 .==1)) ;
    if length(IndCont)>=1
        @inbounds for j=1:length(IndCont)
            statcovid.deb_cont[IndCont[j]] -= 1 ;
        end
    end

    # Pour les gens contaminés, on regarde s'ils sont maintenant contaminants
    IndNewContaminant = findall((contamination0 .== 1) .& (statcovid.deb_cont .== 0))
    if length(IndNewContaminant)>=1
        @inbounds for j=1:length(IndNewContaminant)
            statcovid.contamination[IndNewContaminant[j]] = 2 ;
        end
    end

    # Pour les gens contaminants, on met à jour le temps de contamination
    IndOldContaminant = findall((contamination0 .==2))
    if length(IndOldContaminant)>=1
        @inbounds for j=1:length(IndOldContaminant)
            statcovid.duree_cont[IndOldContaminant[j]] -= 1 ;
        end
    end

    # Pour les gens contaminants, ils sont guéris s'ils ne le sont plus
    IndNewGueri = findall((contamination0 .==2) .& (statcovid.duree_cont .== 0))
    if length(IndNewGueri)>=1
        @inbounds for j = 1:length(IndNewGueri)
            statcovid.contamination[IndNewGueri[j]] = 3 ;
        end
    end

    return()

end


export mise_en_place!
"""
Function MiseEnPlace!
#Fonction permettant de mettre en place des mesures sanitaires
#Entrées :
#- statcovid::Statut_covid
#- indicateur::Int32
#Sorties :

"""
function mise_en_place!(statcovid::Statut_covid,indicateur::Int32)

    if(statcovid.mesure_on == false)
        if(mesures.TRACAGE)
            if(indicateur>Trace.SEUIL_INCIDENCE)
                println("Debut du traçage") ;
                statcovid.mesure_on=true ;
            end
        end

        if(mesures.CONFINEMENT)
            if(indicateur>Confinement.SEUIL_INCIDENCE)
                println("Debut du confinement") ;
                statcovid.mesure_on=true ;
            end
        end

    end

end


export miseajour_mesure!
"""
Function miseajour_mesure!


"""
function miseajour_mesure!(statcovid::Statut_covid,contamination0::Array{Int32,1},contamination1::Array{Int32,1})

    # Si on met en place un confinement
    if(mesures.CONFINEMENT)
        statcovid.jours_conf[1] -= 1 ;
        if(statcovid.jours_conf[1] == 0)
            statcovid.mesure_on = false ;
        end
    end

    # Si on met en place un traçage (confinement si positif)
    #if(mesures.TRACAGE)
    #    miseajour_tracage!(statcovid,contamination0,contamination1)
    #end

end


export miseajour_tracage
"""
Function miseajour_tracage!


"""
function miseajour_tracage!(statcovid::Statut_covid,contamination0::Array{Int32,1},contamination1::Array{Int32,1})

     # Les nouveaux contaminés
     Ind = findall((contamination0 .==0) .& (contamination1 .> 0)) ;
     for i=1:length(Ind)
         if(statcovid.symptome[Ind[i]]==1)
             tps = statcovid.incubation[Ind[i]] + rand([1,2,3,4]) ;
             statcovid.deb_mesure[Ind[i]] = tps+1 ;
         end
     end

     # Mise à jour
     Ind = findall(statcovid.deb_mesure .>= 0) ;
     for i=1:length(Ind)
         statcovid.deb_mesure[Ind[i]] -= 1 ;
     end

     # Confinement ?

    if((statcovid.mesure_on) && (mesures.TRACAGE))

        Ind = findall(statcovid.deb_mesure .== 0)
        if(length(Ind)>0)
            for i=1:length(Ind)
                 statcovid.jours_conf[Ind[i]] = Trace.JOURS_CONF + 1 ;
            end
        end

     #
        Ind = findall(statcovid.jours_conf .> 0)
        if(length(Ind)>0)
            for i=1:length(Ind)
                statcovid.jours_conf[Ind[i]] -= 1 ;
            end
        end

    end


end



export deplacement!
"""
Function Deplacement!

Fonction permettant de définir les déplacements des individus sur toute une journée.
Cette journée est différente selon le statut des individus.
Si une mesure sanitaire est mise en place, alors cette journée est impactée.

Entrées :
- Jour : Structure DefJournee à mettre à jour
- Ville : Structure City contenant les informations sur les lieux et bâtiments
- Individu : Structure Population contenant les informations sur les individus
- statcovid : Structure Statut_covid contenant les informations sur la covid

Sortie :
- Jour : Structure Jour contenant les lieux visités par les individus

"""
#function deplacement!(Jour::DefJournee,Ville::City,Individu::Population,statcovid::Statut_covid)

    # S'il n'y a pas de mesures sanitaires, on calcule normalement les déplacements journaliers
#    if(statcovid.mesure_on == false)
#        @inbounds for i = 1:Individu.nb_pop
#            Jour.id_lieu[i,:], Jour.heure_dep[i,:], Jour.heure_arr[i,:] = journee_indiv(i,Ville,Individu) ;
#        end
#    else
        # Si un confinement est mis en place, alors on appelle une autre fonction de déplacement
#        if(mesures.CONFINEMENT)
#            @inbounds for i = 1:Individu.nb_pop
#                Jour.id_lieu[i,:], Jour.heure_dep[i,:], Jour.heure_arr[i,:] = journee_indiv_conf(i,Ville,Individu,statcovid) ;
#            end
        # Si un confinement individualisé est mis en place, alors on appelle une autre fonction de déplacement
#        elseif(mesures.TRACAGE)
#            @inbounds for i = 1:Individu.nb_pop
#                Jour.id_lieu[i,:], Jour.heure_dep[i,:], Jour.heure_arr[i,:] = journee_indiv_trace(i,Ville,Individu,statcovid) ;
#            end
#        end
#    end

#    return() ;

#end


export deplacement_v2!
"""
Function Deplacement_v2!

Fonction permettant de définir les déplacements des individus sur toute une journée.
Cette journée est différente selon le statut des individus.
Si une mesure sanitaire est mise en place, alors cette journée est impactée.

Entrées :
- Jour : Structure DefJournee à mettre à jour
- Ville : Structure City contenant les informations sur les lieux et bâtiments
- Individu : Structure Population contenant les informations sur les individus
- statcovid : Structure Statut_covid contenant les informations sur la covid

Sortie :
- Jour : Structure Jour contenant les lieux visités par les individus

"""
function deplacement_v2!(Jour::DefJournee,Ville::City,Individu::Population,statcovid::Statut_covid)

    @inbounds for i = 1:Individu.nb_pop
        Jour.id_lieu[i,:], Jour.heure_dep[i,:], Jour.heure_arr[i,:] = journee_indiv(i,Ville,Individu,statcovid) ;
    end

    return() ;

end

export journee_indiv
"""
Function journee_indiv
Fonction permettant de définir la journée d'un individu.

Entrées :
- i_indiv : Indice de l'individu
- Ville : Structure City contenant les informations sur les lieux et bâtiments
- Individu : Structure Population contenant les informations sur les individus

"""
function journee_indiv(i_indiv::Int64,Ville::City,Individu::Population,statcovid::Statut_covid)

    step = choix_step(i_indiv,Individu.statut[i_indiv],statcovid) ;

    id_lieu_local = zeros(Int32,length(step)) ;

    # Pour l'ensemble des étapes journalières
    @inbounds for j = 1:length(step)
        if(step[j] == 1) # L'individu est chez lui
            id_lieu_local[j] = Individu.id_house[i_indiv] ; # On récupère son indice du ménage
        elseif(step[j] == 2) # L'individu va au travail
            id_lieu_local[j] = Individu.id_ind_work[i_indiv] ; # On récupère alors l'indice de son entreprise/école
        elseif((step[j] == 3) & (Individu.id_ind_work[i_indiv] >= 0)) # L'individu va manger
            if(Journee.Proba.RESTO[Individu.statut[i_indiv]] > rand()) # Si je sors au resto
                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv]);
                Prob = vec(Ville.proba_resto[Ind,:]) ;
                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
            else # Sinon, je ne sors pas (je vais à la cantine ou je continue à bosser)
                id_lieu_local[j] = Individu.id_ind_work[i_indiv] ;
            end

        elseif((step[j] == 3) & (Individu.id_ind_work[i_indiv]  == -1)) # Si je suis sortie du 5ème
            id_lieu_local[j] = -1 ;

        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv]  == -1) ) # Je sors faire des courses
            id_lieu_local[j] = - 1 ;

        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv] >= 0) ) # Je sors faire des courses

            if(Journee.Proba.SORTIECOURSES[Individu.statut[i_indiv]] > rand()) # Si je vais faire des courses
                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv]);
                Prob = vec(Ville.proba_resto[Ind,:]) ;
                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
            else # Sinon je rentre chez moi
                id_lieu_local[j] = Individu.id_house[i_indiv] ;
                step[j] = 1 ;
            end

        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv]  == -1) ) # Je sors faire des courses
            id_lieu_local[j] = - 1 ;

        elseif((step[j] == 5) & (Individu.id_ind_work[i_indiv] >= 0 )) # Faire un loisir !

            if(Journee.Proba.sortieSoir[Individu.statut[i_indiv]] > rand())
                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv] );
                Prob = vec(Ville.proba_resto[Ind,:]) ;
                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
            else
                id_lieu_local[j] = Individu.id_house[i_indiv] ;
                step[j] = 1 ;
            end

        end
    end

    # Choix des heures de départ et d'arrivée
    depart, arrivee = heure_indiv(Individu.statut[i_indiv]) ;

    return(id_lieu_local,depart,arrivee) ;

end

export choix_step
"""
Function JourneeIndiv_trace


"""
function choix_step(i_indiv::Int64,statut_indiv::Int32,statcovid::Statut_covid)

    if(statcovid.mesure_on == false)

        step = Journee.Semaine.TYPE[:,statut_indiv] ;

    else
        if(mesures.CONFINEMENT)

            if(statut_indiv == 1) #Actif
                if(statcovid.tele_travail[i_indiv] == 1)
                    step = [1,2,3,2,4,1,1];
                else
                    step = [1,1,1,1,4,1,1] ;
                end

            elseif(statut_indiv == 2) # Etudiant
                if(Confinement.FERMETURE_ECOLE)
                    step = [1,1,1,1,1,1,1];
                else
                    step = [1,2,3,2,1,1,1];
                end

            elseif(statut_indiv == 3) # Ecolier
                if(Confinement.FERMETURE_ECOLE)
                    step = [1,1,1,1,1,1,1];
                else
                    step = [1,2,3,2,1,1,1];
                end

            elseif(statut_indiv == 4) # Retraite
                step = [1,1,4,1,1,1,1] ;
            end

        elseif(mesures.TRACAGE)
            step = Journee.Semaine.TYPE[:,statut_indiv] ;
            if(statcovid.jours_conf[i_indiv]>0)
                step = [1,1,1,1,1,1,1];
            end
        end

    end

    return(step)

end



#export journee_indiv_conf
#"""
#Function JourneeIndiv_conf
#Fonction permettant de définir la journée d'un individu lorsqu'un confinement général est mise en place

#Entrées :
#- i_indiv : Indice de l'individu
#- Ville : Structure City contenant les informations sur les lieux et bâtiments
#- Individu : Structure Population contenant les informations sur les individus



#"""
#function journee_indiv_conf(i_indiv::Int64,Ville::City,Individu::Population,statcovid::Statut_covid)

    # Contrairement à la fonction journee_indiv, on va changer les étapes journalières
#    if(Individu.statut[i_indiv] == 1) #Actif
#        if(statcovid.tele_travail[i_indiv] == 1)
#            step = [1,2,3,2,4,1,1];
#        else
#            step = [1,1,1,1,4,1,1] ;
#        end

#    elseif(Individu.statut[i_indiv] == 2) # Etudiant
#        if(Confinement.FERMETURE_ECOLE)
#            step = [1,1,1,1,1,1,1];
#        else
#            step = [1,2,3,2,1,1,1];
 #       end

#    elseif(Individu.statut[i_indiv] == 3) # Ecolier
#        if(Confinement.FERMETURE_ECOLE)
#            step = [1,1,1,1,1,1,1];
#        else
#            step = [1,2,3,2,1,1,1];
#        end

#    elseif(Individu.statut[i_indiv] == 4) # Retraite
#        step = [1,1,4,1,1,1,1] ;
#    end

#    id_lieu_local = zeros(Int32,length(step)) ;

#    @inbounds for j = 1:length(step)
#       if(step[j] == 1) # Chez lui
#            id_lieu_local[j] = Individu.id_house[i_indiv] ;
#        elseif(step[j] == 2) # Il va au travail
#            id_lieu_local[j] = Individu.id_ind_work[i_indiv] ;
#        elseif((step[j] == 3) & (Individu.id_ind_work[i_indiv] >= 0)) # Je vais manger

#            if(Journee.Proba.resto[Individu.statut[i_indiv]] > rand()) # Si je sors au resto
#                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv]);
#                Prob = vec(Ville.proba_resto[Ind,:]) ;
#                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
#            else # Sinon, je ne sors pas (je vais à la cantine ou je continue à bosser)
#                id_lieu_local[j] = Individu.id_ind_work[i_indiv] ;
#            end

#        elseif((step[j] == 3) & (Individu.id_ind_work[i_indiv]  == -1)) # Si je suis sortie du 5ème
#            id_lieu_local[j] = -1 ;

#        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv]  == -1) ) # Je sors faire des courses
#            id_lieu_local[j] = - 1 ;

#        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv] >= 0) ) # Je sors faire des courses
#            if(Journee.Proba.sortieCourses[Individu.statut[i_indiv]] > rand())
#                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv]);
#                Prob = vec(Ville.proba_resto[Ind,:]) ;
#                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
#            else
#                id_lieu_local[j] = Individu.id_house[i_indiv] ;
#                step[j] = 1 ;
#            end

#        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv]  == -1) ) # Je sors faire des courses
#            id_lieu_local[j] = - 1 ;

#        elseif((step[j] == 5) & (Individu.id_ind_work[i_indiv] >= 0 )) # Faire un loisir !

 #           if(Journee.Proba.sortieSoir[Individu.statut[i_indiv]] > rand())
 #               Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv] );
 #               Prob = vec(Ville.proba_resto[Ind,:]) ;
 #               id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
 #           else
 #               id_lieu_local[j] = Individu.id_house[i_indiv] ;
 #               step[j] = 1 ;
 #           end
#
 #       end
  #  end

  #  depart, arrivee = heure_indiv(Individu.statut[i_indiv]) ;

  #  return(id_lieu_local,depart,arrivee) ;

#end



#export journee_indiv_trace
#"""
#Function JourneeIndiv_trace


#"""
#function journee_indiv_trace(i_indiv::Int64,Ville::City,Individu::Population,statcovid::Statut_covid)


#    step = Journee.Semaine.Type[:,Individu.statut[i_indiv]] ;

#    if(statcovid.jours_conf[i_indiv]>0)
#        step = [1,1,1,1,1,1,1]
#    end

#    id_lieu_local = zeros(Int32,length(step)) ;

#    @inbounds for j = 1:length(step)
#        if(step[j] == 1) # Chez lui
#            id_lieu_local[j] = Individu.id_house[i_indiv] ;
#        elseif(step[j] == 2) # Il va au travail
#            id_lieu_local[j] = Individu.id_ind_work[i_indiv] ;
#        elseif((step[j] == 3) & (Individu.id_ind_work[i_indiv] >= 0)) # Je vais manger

#            if(Journee.Proba.resto[Individu.statut[i_indiv]] > rand()) # Si je sors au resto
#                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv]);
#                Prob = vec(Ville.proba_resto[Ind,:]) ;
#                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
#            else # Sinon, je ne sors pas (je vais à la cantine ou je continue à bosser)
#                id_lieu_local[j] = Individu.id_ind_work[i_indiv] ;
#            end

#        elseif((step[j] == 3) & (Individu.id_ind_work[i_indiv]  == -1)) # Si je suis sortie du 5ème
#            id_lieu_local[j] = -1 ;

#        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv]  == -1) ) # Je sors faire des courses
#            id_lieu_local[j] = - 1 ;

#        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv] >= 0) ) # Je sors faire des courses
#            if(Journee.Proba.sortieCourses[Individu.statut[i_indiv]] > rand())
#                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv]);
#                Prob = vec(Ville.proba_resto[Ind,:]) ;
#                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
#            else
#                id_lieu_local[j] = Individu.id_house[i_indiv] ;
#                step[j] = 1 ;
#            end

#        elseif((step[j] == 4) & (Individu.id_ind_work[i_indiv]  == -1) ) # Je sors faire des courses
#            id_lieu_local[j] = - 1 ;

#        elseif((step[j] == 5) & (Individu.id_ind_work[i_indiv] >= 0 )) # Faire un loisir !

#            if(Journee.Proba.sortieSoir[Individu.statut[i_indiv]] > rand())
#                Ind = findall(Ville.id_work .== Individu.id_ind_work[i_indiv] );
#                Prob = vec(Ville.proba_resto[Ind,:]) ;
#                id_lieu_local[j] = choix_resto(Prob,Ville.id_aliment)  ;
#            else
#                id_lieu_local[j] = Individu.id_house[i_indiv] ;
#                step[j] = 1 ;
#            end

#        end
#    end

#    depart, arrivee = heure_indiv(Individu.statut[i_indiv]) ;

#    return(id_lieu_local,depart,arrivee) ;

#end
