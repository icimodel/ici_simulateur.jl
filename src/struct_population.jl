using MetaGraphs
using LightGraphs
using GraphMLReader
using GraphIO
using TimerOutputs

abstract type MyAbstractPopulation end

export Population 
``` 
Struct Population 

```
struct Population <: MyAbstractPopulation 

    nb_pop::Int32
    id_ind::Array{Int32,1}
    id_house::Array{Int32,1}
    statut::Array{Int32,1}
    indiv_in_out::Array{Int32,1}
    id_ind_work::Array{Int32,1}
    tissu_work::Array{Int32,1}
    cat_age::Array{Int32,1}

    function Population()

        name_file = ParamFile.GRAPH_FILE ;
        graph = loadgraphml("Data/$(lpad(name_file,1)).graphml") ;
        n_node = nv(graph) ;
        id_ind, id_house, cat_age = individual(graph,n_node) ;
        id_work, area_work = working_place(graph,n_node) ;
        nb_pop_graph = length(id_ind) ;
        statut = def_statut(cat_age) ;
        indiv_in_out,statut,id_house = indiv_inout(statut,id_house) ;
        nb_pop = nb_pop_graph + ParamPop.NB_IN ;
        id_ind_work,tissu_work = choix_travail(statut,indiv_in_out,id_work,area_work) ;

        return new(
        nb_pop,
        id_ind,
        id_house,
        statut,
        indiv_in_out,
        id_ind_work,
        tissu_work,
        cat_age
        )

    end

end


"""
Individual(graph, n_node)

    # Function used to find the id node of all individuals
    # Input:
    # - graph: undirected Int64 metagraph with Float64 weights
    # - n_node ({Int32}): total number of nodes
    # Output:
    # - id_indiv (Array{Int32,.}): Vector containing the id of all individuals
    # - id_house (Array{Int32,.}): Vector containing the id of the corresponding house
    # - cat_age (Array{Int32,.}): Vector containing the age category

"""
function individual(graph::MetaGraph,n_node::Int)

    # Initialisation of the vectors
    id_indiv = Array{Int32}([]) ;
    id_house = Array{Int32}([]) ;
    cat_age = Array{Int32}([]) ;
    x = ["a0_2","a3_5","a6_10","a11_17","a18_24","a25_39","a40_54","a55_64","a65_79","a80p"] ;

    # Find the nodes corresponding to the individuals
    @inbounds for i=1:n_node
        if(get_prop(graph,i,:type)=="Individual")
            append!(id_indiv,i) ;
        end
    end

        # Find the households of each individuals and the age category
    @inbounds for i=1:length(id_indiv)
        ind_age = findall(x.==get_prop(graph,id_indiv[i],:AgeClass)) ;
        push!(cat_age,ind_age[1]) ;
        neigh = neighbors(graph,id_indiv[i])[1] ; 
        # Pour les individus ayant un ménage :
        if(get_prop(graph,neigh,:type)=="Household") 
            push!(id_house,neighbors(graph,id_indiv[i])[1]) ;
        else # Les individus sont en hébergement 
            push!(id_house,-id_indiv[i]-1) ; 
        end 
    end

    return(id_indiv,id_house,cat_age) ;

end

"""
Function DefStatut 
#Fonction permettant de définir les statuts sociales des individus : actif, étudiant, écolier, retraité 
#Entrées : 
#- cat_age::Array{Int32,1}
#Sorties :
#- statut::Array{Int32,1}
"""
function def_statut(cat_age::Array{Int32,1})

    # Actif == 1
    statut = ones(Int32,length(cat_age)) ;
    # Etudiant == 2
    statut[findall(cat_age .== 5)] .= 2 ;
    # Ecolier == 3
    statut[findall(cat_age .<=4)] .= 3 ;
    # Retraite == 4
    statut[findall(cat_age .>= 9)] .= 4 ;

    return(statut)

end


"""
Function Indiv_InOut 
#Fonction permettant de mettre en place les individus entrant et sortant du quariter 
#Entrées : 
#- statut::Array{Int32,1}
#- id_house::Array{Int32,1}
#Sorties : 
#- indiv_in_out::Array{Int32,1}
#- statut::Array{Int32,1}
#- id_house::Array{Int32,1}
"""
function indiv_inout(statut::Array{Int32,1},id_house::Array{Int32,1})

    # Définition des sorties (travail + resto = -1)
    if((ParamPop.NB_OUT == 0) & (ParamPop.NB_IN == 0))
        indiv = zeros(Int32,length(statut)) ;
        return(indiv,statut,id_house) ;
    elseif((ParamPop.NB_OUT > 0) & (ParamPop.NB_IN == 0))
        indiv = def_indiv_out(statut) ;
        return(indiv,statut,id_house) ;
    elseif((ParamPop.NB_OUT == 0) & (ParamPop.NB_IN > 0))
        indiv_out = zeros(Int32,length(statut)) ;
        indiv_in_out,statut,id_house = def_indiv_in(indiv_out,statut,id_house) ;
        return(indiv_in_out,statut,id_house) ;
    elseif((ParamPop.NB_OUT > 0) & (ParamPop.NB_IN > 0))
        indiv = def_indiv_out(statut) ;
        indiv_in_out,statut,id_house = def_indiv_in(indiv,statut,id_house) ;
        return(indiv_in_out,statut,id_house) ;
    end

end


"""
Function Indiv_In 
#Fonction permettant de mettre en place les individus qui entrent pour travailler au sein du quartier 
#Entrées : 
#- indiv_out::Array{Int32,1}
#- statut::Array{Int32,1}
#- id_house::Array{Int32,1}
#Sorties : 
#- indiv_in_out::Array{Int32,1}
#- statut::Array{Int32,1}
#- id_house::Array{Int32,1} 

"""
function def_indiv_in(indiv_out::Array{Int32,1},statut::Array{Int32,1},id_house::Array{Int32,1})

    indiv_in_out = zeros(Int32,length(statut)+ParamPop.NB_IN) ;
    indiv_in_out[1:length(statut)] .= indiv_out ;
    # Il faudra mettre à -1 les gens qui entrent pour travailler.
    indiv_in_out[length(statut)+1:length(statut)+ParamPop.NB_IN] .= -1 ;
    # Mettre à jour le statut
    nb_etud = Int(floor(ParamPop.NB_IN*ParamPop.TAUX_ETUD)) ;
    statut_out = ones(Int32,ParamPop.NB_IN) ;
    statut_out[1:nb_etud] .= 2 ;

    id_house_out = zeros(Int32,ParamPop.NB_IN) ;
    id_house_out .= -1 ;

    @inbounds for i=1:length(statut_out)
        push!(statut,statut_out[i]) ;
        push!(id_house,id_house_out[i]) ;
    end

    return(indiv_in_out, statut, id_house) ;

end

"""
Function Indiv_Out
#Fonction permettant de mettre en place les individus qui sortent pour travailler en dehors du quartier 
#Entrée : 
#- statut::Array{Int32,1}
#Sorties : 
#- indiv_out::Array{Int32,1}
"""
function def_indiv_out(statut::Array{Int32,1})

    etud_actif = findall(statut .<= 2) ;
    indiv_out = zeros(Int32,length(statut)) ;
    out = zeros(Int32,length(etud_actif)) ;
    out[1:ParamPop.NB_OUT] .= 1 ;
    shuffle!(out) ;
    indiv_out[etud_actif] = out ;

    return(indiv_out) ;

end

"""
Function ChoixTravail 
#Fonction permettant d'associer une entreprise à un individu ainsi que le tissu social (~collègues proches)
#Entrées : 
#- statut::Array{Int32,1}
#- indiv_in_out::Array{Int32,1}
#- id_work::Array{Int32,1}
#- area_work::Array{Float64,1}
#Sorties : 
#- id_ind_work::Array{Int32,1}
#- tissu_work::Array{Int32,1}
"""
function choix_travail(statut::Array{Int32,1},indiv_in_out::Array{Int32,1},id_work::Array{Int32,1},area_work::Array{Float64,1})

    actif = findall(statut .== 1) ;
    ecolier = findall(statut .== 3) ;

    etudiant_interieur = findall((indiv_in_out .< 1) .& (statut .== 2)) ;

    id_ind_work = zeros(Int32,length(statut)) ;

    q_etud = div(length(etudiant_interieur),ParamPop.NBPERAMPHI) ;
    q_ecol = div(length(ecolier), ParamPop.NBPERCLASS) ;

    Repartition = distribution_workingplace(actif,id_work,area_work) ;

    i_class = 300000 ;
    i_amphi = 400000 ;
    cpt = 1 ;

    @inbounds for i=1:length(statut)

        if((statut[i] == 1) & (indiv_in_out[i] <= 0)) #actif au sein du 5ème
            id_ind_work[i] = Repartition[cpt] ;
            cpt = cpt + 1 ;
        elseif((statut[i] == 1) & (indiv_in_out[i] == 1)) #actif extérieur
            id_ind_work[i] = -1 ;
        elseif((statut[i] == 2) & (indiv_in_out[i] < 1)) # etudiant au sein du 5ème
            id_ind_work[i] = floor(Int,rand(Uniform(1,q_etud+1))) + i_amphi ;
        elseif((statut[i] == 2) & (indiv_in_out[i] == 1)) # etudiant extérieur
            id_ind_work[i] = -1 ;
        elseif(statut[i] == 4) # retraité
            id_ind_work[i] = -1 ;
        elseif(statut[i] == 3)
            id_ind_work[i] = floor(Int,rand(Uniform(1,q_ecol+1))) + i_class ;
        end

    end

    # Définition du tissu social
    tissu_work = tissu(id_ind_work) ;

    return(id_ind_work, tissu_work) ;

end

"""
Function RepartitionEntreprise 
#Fonction permettant de repartir les individus au sein des entreprises 
#Entrées : 
#- actif::Array{Int64,1}
#- id_work::Array{Int32,1}
#- area_work::Array{Float64,1}
#Sorties : 
#- Repartition::Array{Int64,1}
"""
function distribution_workingplace(actif::Array{Int64,1},id_work::Array{Int32,1},area_work::Array{Float64,1})

    nb_entr = length(id_work) ;
    nb_mean_per_entr = floor.(Int32,div.(area_work,ParamPop.M2_EMPLOY)) ;
    nb_total_mean = sum(nb_mean_per_entr) ;
    repartition = [] ;

    @inbounds for i=1:nb_entr
        append!(repartition,ones(Int32,nb_mean_per_entr[i])*id_work[i]) ;
    end

    reste = length(actif) - nb_total_mean ;

    if(reste > 0)
        for j=1:reste
            append!(repartition, id_work[floor(Int,rand(Uniform(1,nb_entr)))]) ;
        end
    end


    shuffle!(repartition) ;

    return(repartition) ;


end

"""
Function Tissu_social 
#Fonction permettant de mettre en place un tissu social au sein de l'entreprise. Ce sont des personnes qui seront plus proches entre eux. 
#Entrées : 
#- Structure::Array{Int32,1}
#Sorties : 
#- Structure::Array{Int32,1}
"""
function tissu_social(Structure::Array{Int32,1})

    nb_actif = length(Structure) ;
    cpt = nb_actif ;
    cpt2 = 0 ;
    fin = 1 ;

    while(cpt >= 0)

        s = rand(Poisson(ParamPop.LAMBDA_TISSU)) ;
        cpt = cpt - s ;
        deb = fin ;
        fin = deb+s ;
        if(fin>nb_actif)
            fin = nb_actif ;
        end

        Structure[deb:fin] .= cpt2 ;
        cpt2 = cpt2 + 1 ;

    end

    return(Structure) ;

end

"""
Function Tissu 

"""
function tissu(id_ind_work::Array{Int32,1})

    tissu = zeros(Int32,length(id_ind_work)) ;
    d = Dict([(i,count(x->x.==i,id_ind_work)) for i in unique(id_ind_work)]) ;
    dr = collect(keys(d)) ;

    @inbounds for i=1:length(dr)

        if(dr[i] > 0)
            Ind_work = findall(id_ind_work .== dr[i]) ;
            Structure = zeros(Int32,length(Ind_work)) ;
            tissu_s = tissu_social(Structure) ;
            tissu[Ind_work] = tissu_s ;
        end
    end

    return(tissu) ;

end
