using Dates

export def_parametre_input

"""
Def_Parametre_Input(name_folder,name_file_graph)

    Function used to define a file with all of the input data used in the modeling.
    This function creates a txt file named Input_Data.txt

    Input:
    - name_folder::String (name of the folder where the file is created)
    - name_file_graph::String (name of the graph used in the modeling)
    Output:
    - NaN

"""
function def_parametre_input(name_folder,name_file_graph::String)

    open("Res/$(lpad(name_folder,1))/Input_Data.txt", "a+") do io
        # Parameters of the modeling
        writedlm(io, ["Name_graph_file" name_file_graph])
        writedlm(io, ["ParamSimu.nb_day" ParamSimu.NB_DAY])
        writedlm(io, ["ParamSimu.nb_cont" ParamSimu.NB_CONT])
        writedlm(io, ["ParamSimu.nb_MC" ParamSimu.NB_MC])
        # Parameters of the covid
        writedlm(io, ["ParametreCovid.mu_incub" ParametreCovid.MU_INCUB])
        writedlm(io, ["ParametreCovid.sigma_incub" ParametreCovid.SIGMA_INCUB])
        writedlm(io, ["ParametreCovid.mu_dt_cont" ParametreCovid.MU_DT_CONT])
        writedlm(io, ["ParametreCovid.sigma_dt_cont" ParametreCovid.SIGMA_DT_CONT])
        writedlm(io, ["ParametreCovid.mu_deb" ParametreCovid.MU_DEB])
        writedlm(io, ["ParametreCovid.sigma_deb" ParametreCovid.SIGMA_DEB])
        writedlm(io, ["ParametreCovid.mu_prob" ParametreCovid.MU_PROB])
        writedlm(io, ["ParametreCovid.sigma_prob" ParametreCovid.SIGMA_PROB])
        # Parameters of the population
        writedlm(io, ["ParamPop.nb_out" ParamPop.NB_OUT])
        writedlm(io, ["ParamPop.nb_in" ParamPop.NB_IN])
        writedlm(io, ["ParamPop.taux_etud" ParamPop.TAUX_ETUD])
        writedlm(io, ["ParamPop.nbperclass" ParamPop.NBPERCLASS])
        writedlm(io, ["ParamPop.nbperamphi" ParamPop.NBPERAMPHI])
        writedlm(io, ["ParamPop.lambda_tissu" ParamPop.LAMBDA_TISSU])
        writedlm(io, ["ParamPop.m2_employ" ParamPop.M2_EMPLOY])
        # Module DistanceC
        writedlm(io, ["DistanceC.minD_tissu" DistanceC.MIN_TISSU])
        writedlm(io, ["DistanceC.maxD_tissu" DistanceC.MAX_TISSU])
        writedlm(io, ["DistanceC.minD_htissu" DistanceC.MIN_HTISSU])
        writedlm(io, ["DistanceC.maxD_htissu" DistanceC.MAX_HTISSU])
        writedlm(io, ["DistanceC.minD_menage" DistanceC.MIN_MENAGE])
        writedlm(io, ["DistanceC.maxD_menage" DistanceC.MAX_MENAGE])
        writedlm(io, ["DistanceC.minD_resto" DistanceC.MIN_RESTO])
        writedlm(io, ["DistanceC.maxD_resto" DistanceC.MAX_RESTO])
        # Module Journee
        #writedlm(io, ["Journee.Semaine.min_dep",Journee.Semaine.min_dep])
        #writedlm(io, ["Journee.Semaine.max_dep",Journee.Semaine.max_dep])
        #writedlm(io, ["Journee.Semaine.min_arr",Journee.Semaine.min_arr])
        #writedlm(io, ["Journee.Semaine.max_arr",Journee.Semaine.min_arr])
        #writedlm(io, ["Journee.Semaine.Type",Journee.Semaine.Type])
        #writedlm(io, ["Journee.Semaine.Deb_Type",Journee.Semaine.Deb_Type])
        #writedlm(io, ["Journee.Semaine.Fin_Type",Journee.Semaine.Fin_Type])
        #writedlm(io, ["Journee.Proba.sortieJournee",Journee.Proba.sortieJournee])
        #writedlm(io, ["Journee.Proba.resto",Journee.Proba.resto])
        #writedlm(io, ["Journee.Proba.sortieSoir",Journee.Proba.sortieSoir])
        #writedlm(io, ["Journee.Proba.sortieCourses",Journee.Proba.sortieCourses])

    end

end

export parallelisation
"""
Parallelisation()

    Function used to define the parallelization. The function returns the rank of the processus

    Input:
    - NaN
    Output:
    - comm
    - rank::Int

"""
function parallelisation()

    if(ParamSimu.vMPI)
        MPI.Init() ;
        comm = MPI.COMM_WORLD ;
        # Nombre de processus alloué à la parallélisation
        # nbproc = MPI.Comm_size(comm) ;
        # Numéro du rang du processus en cours
        rank = MPI.Comm_rank(comm) ;
        #println("Je suis le processus ", rank, " parmi ", nbproc , " processus")
    else
        rank = 0 ;
        println("La simulation ne tourne que sur un processus !")
        comm = 0 ;
    end

    return(comm,rank)

end


"""
Function DistanceResto
Fonction permettant de définir la distance la plus courte entre une entreprise et l'ensemble des services de restaurations.
"""
function distance_resto(id_aliment::Array{Int32,1},id_work::Array{Int32,1})

    simple_graph = loadgraph("Data/SaintVicNoChildrenLeftBehind.graphml", GraphIO.GraphML.GraphMLFormat()) ;

    chemin = zeros(Int32,(length(id_work),length(id_aliment))) ;

    @time for i = 1:length(id_work)
        for j=1:length(id_aliment)
            ch = a_star(simple_graph,id_work[i],id_aliment[j]) ;
            chemin[i,j] = length(ch) ;
        end

        println("J\'ai fini la",i,"eme entreprise")

    end

    f = writedlm("Data/Distance_resto.txt", chemin) ;

    return()

end
