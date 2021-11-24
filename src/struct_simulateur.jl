using Dates

abstract type MyAbstractSimulateur end 

export Simulateur 
"""
Struct Simulateur 

"""
struct Simulateur <: MyAbstractSimulateur 

    Indicateur_prop::Indicateur
    name_folder::String

    function Simulateur(Ville::City,Individu::Population,rank::Int)

        A = Indicateur(Individu.nb_pop) ;

        if(ParamSimu.vMPI)
            if(ParamSimu.CALCULATEUR)
                name_folder = split(pwd(),"/")[end] ;
            else
                name_folder = "Res_MPI" ;
            end
        else
            name_folder = Dates.format(now(), "yyyy-mm-ddTHHMMSS") ;
            #mkdir("Res/$(lpad(name_folder,1))") ;
        end

        if(rank==0)
            mkdir("Res/$(lpad(name_folder,1))") ;
            mkdir("Res/$(lpad(name_folder,1))/txt_file/") ;
            mkdir("Res/$(lpad(name_folder,1))/json_file/") ;
            def_parametre_input(name_folder,Ville.name_file) ;
        end

        for i_MC = 1:ParamSimu.NB_MC
            StatutCovid = Statut_covid(Individu) ;
            compute_spreading(A,i_MC,StatutCovid,Ville,Individu) ;
        end

        return new(A,name_folder)

    end

end



function compute_spreading(A::Indicateur, iMC::Int64, statcovid::Statut_covid,Ville::City,Individu::Population)

    Jour = DefJournee(Individu.nb_pop,length(JourneeType.Ecolier)) ;

    for i_day=1:ParamSimu.NB_DAY

        whereis_local = Array{Int32}([]) ;
        if(ParamSimu.PRINT_ETAT)
            println("Calcul en cours pour le jour : ", i_day)
        end 
        deplacement_v2!(Jour,Ville,Individu,statcovid) ;
        # On calcule la contamination possible de chaque individu
        contamination_sim = copy(statcovid.contamination) ;
        # Contamination au sein du 5ème arrondissement
        contamination_fct!(statcovid,whereis_local,i_day,Jour,Individu.tissu_work,Individu.statut) ;
        # Contamination en dehors du 5ème arrondissement
        incidence = statslieu_contamination(whereis_local,Ville,Individu) ;
        contamination_externe!(statcovid,incidence,Individu.statut,Individu.indiv_in_out) ;
        # On calcule les indicateurs de suivi de propagation de l'épidémie
        compute_indicateur!(A,iMC,i_day,contamination_sim,statcovid.contamination,Individu.indiv_in_out,statcovid.deb_mesure) ;
        if(ParamSimu.PRINT_ETAT)
            println("Nouvelle contamination : ", A.Nnew_cont_MC[i_day+1,iMC])
            println("Avec biais : ", A.Incidence_biais[i_day+1,iMC])
        end 
        mise_a_jour!(statcovid,contamination_sim) ;
        miseajour_tracage!(statcovid,contamination_sim,statcovid.contamination) ; 

        if((mesures.INTERVENTION) & (statcovid.mesure_on == false))
            mise_en_place!(statcovid,A.Incidence_biais[i_day+1,iMC]) ;
            #println("statut : ", statcovid.mesure_on)
        elseif(statcovid.mesure_on)
            miseajour_mesure!(statcovid,contamination_sim,statcovid.contamination) ;
            #println("Mise à jour du ptit confinement")
        end



    end

    return() ;

end
