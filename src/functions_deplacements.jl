"""
Function heure_indiv 

"""
function heure_indiv(statut::Int32)

    heure_depart = Journee.Semaine.Deb_Type ;
    heure_arrivee = Journee.Semaine.Fin_Type ;

    return(heure_depart,heure_arrivee)

end


"""
Function choix_resto 


"""
function choix_resto(Prob::Array{Float64,1},id_aliment::Array{Int32,1})

    
    if(sum(Prob) > 0.5)
        id_lieu_loc = id_aliment[rand(Categorical(Prob))] ;
    else
        id_lieu_loc = id_aliment[floor(Int,rand(Uniform(1,length(id_aliment))))] ; 
    end

    return(id_lieu_loc) ; 

end


