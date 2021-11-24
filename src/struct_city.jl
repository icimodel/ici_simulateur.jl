using MetaGraphs
using LightGraphs
using GraphMLReader
using GraphIO
using TimerOutputs

abstract type MyAbstractCity end 

"""
Structure City 
Instantiate a structure contening the information about the city (POI, Working Place, etc.)

name_file::String : name of the graph file (in graphml format)
n_node::Int32 : number of nodes of the graph
id_poi::Array{Int32,1} : id of all POI 
id_aliment::Array{Int32,1} : id of all restaurants 
id_ecole::Array{Int32,1} : id of all school 
id_work::Array{Int32,1} : id of all working place
area_work::Array{Float64,1} : area of all working place (expressed in m2)
proba_resto::Array{Float64,2} : probability to go to the restaurant for each working place 
""" 

export City 

struct City <: MyAbstractCity

    name_file::String
    n_node::Int32
    id_poi::Array{Int32,1}
    id_aliment::Array{Int32,1}
    id_ecole::Array{Int32,1}
    id_work::Array{Int32,1}
    area_work::Array{Float64,1}
    proba_resto::Array{Float64,2}

    function City()

        # Read the graph file (from GraphMLReader)
        name_file = ParamFile.GRAPH_FILE ;
        graph = loadgraphml("Data/$(lpad(name_file,1)).graphml") ;
        # Compute the number of nodes (nv: LightGraphs)
        n_node = nv(graph) ;
        # Find the id of POI, food and school
        id_poi, id_aliment, id_ecole = poi(graph,n_node) ;
        # find the id of Working Place and the area expressed in m2 
        id_work, area_work = working_place(graph,n_node) ;
        # Compute the probability to go to the restaurant for each working place
        if(Journee.CHOIX_ALEATOIRE_RESTO)
            proba_resto = ones(Float64,(length(id_work),length(id_aliment)))/length(id_aliment) ; 
        else
            proba_resto = proba_restaurant() ;
        end 

        return new(
        name_file,
        n_node,
        id_poi,
        id_aliment,
        id_ecole,
        id_work,
        area_work,
        proba_resto
        )

    end

end



"""
POI(graph, n_node)

    Function used to find the id node of all POI
    Input:
    - graph: undirected Int64 metagraph with Float64 weights
    - n_node ({Int32}): total number of nodes
    Output:
    - id_poi (Array{Int32,.}): Vector containing the id of all POI

"""
function poi(graph::MetaGraph,n_node::Int)

    # Initialisation of the vector
    id_poi = Array{Int32}([]) ;

    # Find all nodes of POI type
    @inbounds for i=1:n_node
        if(get_prop(graph,i,:type)=="POI")
            append!(id_poi,i) ;
        end
    end

    id_aliment = Array{Int32}([]) ;

    @inbounds for i=1:length(id_poi)
        type_poi = get_prop(graph,id_poi[i],:typeNameICI) ;
        if((type_poi == "loisir.restauration") || (type_poi == "commerce.alimentation"))
            append!(id_aliment,i) ;
        end

    end

    id_aliment = id_poi[id_aliment] ;

    id_ecole = Array{Int32}([]) ;

    @inbounds for i=1:length(id_poi)
        type_poi = get_prop(graph,id_poi[i],:typeNameICI) ;
        if((type_poi == "education.primaire") || (type_poi == "education.secondaire") || (type_poi == "education.superieure") || (type_poi == "education.particuliere") )
        #if((type_poi == "education.primaire") || (type_poi == "education.secondaire"))
            append!(id_ecole,i) ;
        end
    end

    id_ecole = id_poi[id_ecole] ;


    return(id_poi,id_aliment, id_ecole)

end

"""
WorkingPlace(graph, n_node)

    Function used to find the id node of all working place
    Input:
    - graph: undirected Int64 metagraph with Float64 weights
    - n_node ({Int32}): total number of nodes
    Output:
    - id_work (Array{Int32,.}): Vector containing the id of all working place
    - area_work (Array{Int32,.}): Vector containing the area of each working place

"""
function working_place(graph::MetaGraph,n_node::Int)

    id_work = Array{Int32}([]) ;

    @inbounds for i=1:n_node
        if(get_prop(graph,i,:type)=="WorkingPlace")
            append!(id_work,i) ;
        end
    end

    n_work = length(id_work) ;
    area_work = rand(Uniform(50,1500),n_work) ;

    return(id_work,area_work)

end


"""
Function proba_restaurant() 
Fonction permettant de définir une probabilité liée à la distance entre le restaurant et l'entreprise

"""
function proba_restaurant()

    distance = readdlm("Data/Distance_resto.txt") ;
    nb_resto = size(distance,2) ;
    nb_travail = size(distance,1) ;
    proba_resto = zeros(Float64,(nb_travail,nb_resto)) ;

    @inbounds for i=1:nb_travail
        Ind = findall(distance[i,:] .!= 0) ;
        nb = sum(1/distance[i,Ind]) ;
        proba_resto[i,Ind] = (1/distance[i,Ind]/nb) ;
    end

    return(proba_resto) ;

end
