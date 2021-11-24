abstract type MyAbstractIndic end 

export Indicateur 
"""
struct Indicateur 
    

"""

struct Indicateur <: MyAbstractIndic

    Ntotal_cont_MC::Array{Int32,2}
    Ntotal_sain_MC::Array{Int32,2}
    Nnew_cont_MC::Array{Int32,2}
    Ncontamination_MC::Array{Int32,2}
    Ngueri_MC::Array{Int32,2}
    Incidence_biais::Array{Int32,2}

    function Indicateur(nb_pop::Int32)

        Ntotal_cont_MC = zeros(Int32, (ParamSimu.NB_DAY+1,ParamSimu.NB_MC)) ;
        Ntotal_cont_MC[1,:] .= ParamSimu.NB_CONT ;
        # Nombre total d'individus sains
        Ntotal_sain_MC = zeros(Int32, (ParamSimu.NB_DAY+1,ParamSimu.NB_MC)) ;
        Ntotal_sain_MC[1,:] .= nb_pop - ParamPop.NB_IN ;
        # Nombre de nouvelles contaminations par jour
        Nnew_cont_MC = zeros(Int32, (ParamSimu.NB_DAY+1,ParamSimu.NB_MC)) ;
        # Nombre de contaminants par jour
        Ncontamination_MC = zeros(Int32, (ParamSimu.NB_DAY+1, ParamSimu.NB_MC)) ;
        Ncontamination_MC[1,:] .= ParamSimu.NB_CONT ;
        # Nombre de guéris
        Ngueri_MC = zeros(Int32, (ParamSimu.NB_DAY+1,ParamSimu.NB_MC)) ;
        # Pour les statistiques sur l'incidence
        #Incidence_MC = zeros(Float64,(ICI_simulateur.ParamSimu.nb_day,4,ICI_simulateur.ParamSimu.nb_MC)) ;
        Incidence_biais = zeros(Int32, (ParamSimu.NB_DAY+1,ParamSimu.NB_MC)) ;

        return new(Ntotal_cont_MC,Ntotal_sain_MC,Nnew_cont_MC,Ncontamination_MC,Ngueri_MC,Incidence_biais)

    end



end


"""
function Compute_Indicateur 
#Fonction permettant de calculer les indicateurs épidémiologiques 
"""
function compute_indicateur!(Indic::Indicateur,iMC::Int64,iday::Int64, contamination0::Array{Int32,1},contamination1::Array{Int32,1},indiv_in_out::Array{Int32,1},deb_mesure::Array{Int32,1})

    # Nombre total de contaminés
    Indic.Ntotal_cont_MC[iday+1,iMC] = length(findall((contamination1 .> 0) .& (indiv_in_out .>=0))) ;
    # Nombre total de personnes saines
    Indic.Ntotal_sain_MC[iday+1,iMC] = length(findall((contamination1 .==0) .& (indiv_in_out .>=0))) ;
    # Nombre de nouvelles contaminations
    Ind = findall((contamination0 .==0) .& (contamination1 .> 0)) ;
    Indic.Nnew_cont_MC[iday+1,iMC] = length(Ind) ;
    # Indicateur biaisé
    #@inbounds for i=1:length(Ind)
    #    if(symptome[Ind[i]]==1)
    #        tps = incub[Ind[i]] + rand([1,2,3,4]) ;
    #        if(iday+tps+1<ParamSimu.NB_DAY)
    #            Indic.Incidence_biais[iday+1+tps,iMC] += 1 ;
    #        end
    #    end
    #end
    Ind = findall(deb_mesure .== 1) ; 
    Indic.Incidence_biais[iday+1,iMC] = length(Ind) ;
    # Nombres de contaminants
    Indic.Ncontamination_MC[iday+1,iMC] = length(findall(contamination1 .== 2)) ;
    # Nombre de guéris
    Indic.Ngueri_MC[iday+1,iMC]= length(findall((contamination1 .== 3) .& (indiv_in_out .>=0))) ;

    return() ;

end
