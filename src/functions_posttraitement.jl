```
Function Save : 
Save the main indicator on a txt file or a json file 

```


export save 

function save(Propagation::Simulateur,rank::Int,comm)

    if(ParamSimu.vMPI)
        if(ParamFile.vTXT)
            save_txtfile_MPI(Propagation,rank) ;
        end
        if(ParamFile.vJSON)
            save_jsonfile_MPI(Propagation,rank) ;
        end
    else
        if(ParamFile.vTXT)
            save_txtfile(Propagation) ;
        end
        if(ParamFile.vJSON)
            save_indicators_JSON(Propagation) ;
        end
    end

    if(ParamSimu.vMPI)
        MPI.Barrier(comm) ;
    end

    if(rank == 0)
        if(ParamFile.CSV_PARAM)
            write_CSV(Propagation.name_folder)
        end
        if(ParamSimu.vMPI)
            if(ParamFile.MEAN_MC)
                if(ParamFile.vTXT)
                    interval_file(Propagation.name_folder,MPI.Comm_size(comm))
                end
                if(ParamFile.vJSON)
                    interval_file_json(Propagation.name_folder,MPI.Comm_size(comm))
                end
            end
        end
    end

end




"""
Save_indicators(resultat,name_file)

    # Function used to write the result of the modeling into a txt file
    # Input:
    # - resultat:
    # - name_file: name of the file
    # Output :
    # NO OUTPUT

    # This function needs the library DelimitedFiles

"""
function save_indicators(resultat,name_file::String)

    f = writedlm("$(lpad(name_file,1)).txt", resultat) ;
    return() ;

end

"""
Save_indicators_json(resultat,name_file)

    # Function used to write the result of the modeling into a txt file
    # Input:
    # - resultat:
    # - name_file: name of the file
    # Output :
    # NO OUTPUT

    # This function needs the library JSON

"""
function save_indicators_jsonfile(resultat,name_file::String)

    B = Dict("x"=>resultat) ;
    j = JSON.json(B) ;
    open("$(lpad(name_file,1)).json","w") do f
        write(f,j)
    end
    return() ;

end



"""
Confidence_interval(resultat,alpha)

    # Function used to compute the confidence interval of each parameter
    # of the modeling
    # Input:
    # - resultat:
    # - alpha: alpha-confidence
    # Output:
    # - Interv: Matri containing the confidence interval of the indicator

"""
function confidence_interval(resultat)

    # Initialisation of the interval
    N = size(resultat,1) ;
    interv = zeros(Float64,(N,3)) ;

    # For each modeling, we compute the
    @inbounds for i=1:N
        interv[i,1] = mean(resultat[i,:]) ; # Calcul de la moyenne empirique
        interv[i,2] = quantile(resultat[i,:],0.1) ; # Calcul du quartile empirique
        interv[i,3] = quantile(resultat[i,:],0.9) ; # Calcul du quartile empirique
    end

    return(interv)

end



function save_indicators_JSON(Propagation::Simulateur)

    Interv = confidence_interval(Propagation.Indicateur_prop.Ntotal_cont_MC) ;
    Ncont = Interv[:,1] ;
    Ncontp = Interv[:,3] ;
    Ncontm = Interv[:,2] ;

    Interv = confidence_interval(Propagation.Indicateur_prop.Ntotal_sain_MC) ;
    Nsain = Interv[:,1] ;
    Nsainp = Interv[:,3] ;
    Nsainm = Interv[:,2] ;

    Interv = confidence_interval(Propagation.Indicateur_prop.Nnew_cont_MC) ;
    Nnewcont = Interv[:,1] ;
    Nnewcontp = Interv[:,3] ;
    Nnewcontm = Interv[:,2] ;

    Interv = confidence_interval(Propagation.Indicateur_prop.Incidence_biais) ;
    Nbiais = Interv[:,1] ;
    Nbiaisp = Interv[:,3] ;
    Nbiaism = Interv[:,2] ;

    Interv = confidence_interval(Propagation.Indicateur_prop.Ncontamination_MC) ;
    Ncontamin = Interv[:,1] ;
    Ncontaminp = Interv[:,3] ;
    Ncontaminm = Interv[:,2] ;

    Interv = confidence_interval(Propagation.Indicateur_prop.Ngueri_MC) ;
    Ngueri = Interv[:,1] ;
    Nguerip = Interv[:,3] ;
    Nguerim = Interv[:,2] ;

    n_x = size(Propagation.Indicateur_prop.Ntotal_cont_MC,1) ;
    x = float([0:1:n_x;]) ;

    id = ["Ncont","Ncontp","Ncontm","Nsain","Nsainm","Nsainp","Nnewcont",
    "Nnewcontp","Nnewcontm","Nbiais","Nbiaisp","Nbiaism","Ncontamin","Ncontaminp","Ncontaminm",
    "Ngueri","Nguerip","Nguerim"] ;

    B = Dict("x"=>x) ;
    push!(B,"$(id[1])"=>Ncont) ;
    push!(B,"$(id[2])"=>Ncontp) ;
    push!(B,"$(id[3])"=>Ncontm) ;
    push!(B,"$(id[4])"=>Nsain) ;
    push!(B,"$(id[5])"=>Nsainp) ;
    push!(B,"$(id[6])"=>Nsainm) ;
    push!(B,"$(id[7])"=>Nnewcont) ;
    push!(B,"$(id[8])"=>Nnewcontp) ;
    push!(B,"$(id[9])"=>Nnewcontm) ;
    push!(B,"$(id[10])"=>Nbiais) ;
    push!(B,"$(id[11])"=>Nbiaisp) ;
    push!(B,"$(id[12])"=>Nbiaism) ;
    push!(B,"$(id[13])"=>Ncontamin) ;
    push!(B,"$(id[14])"=>Ncontaminp) ;
    push!(B,"$(id[15])"=>Ncontaminm) ;
    push!(B,"$(id[16])"=>Ngueri) ;
    push!(B,"$(id[17])"=>Nguerip) ;
    push!(B,"$(id[18])"=>Nguerim) ;

    j=  JSON.json(B) ;

    open("Res/$(lpad(Propagation.name_folder,1))/json_file/resultat.json","w") do f
        write(f, j)
    end

    return() ;

end


function save_txtfile_MPI(Propagation::Simulateur,rank::Int)

    save_indicators(Propagation.Indicateur_prop.Ntotal_cont_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ntotal_cont_Jussieu_$rank") ;
    save_indicators(Propagation.Indicateur_prop.Ntotal_sain_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ntotal_sain_Jussieu_$rank") ;
    save_indicators(Propagation.Indicateur_prop.Nnew_cont_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Nnew_cont_Jussieu_$rank") ;
    save_indicators(Propagation.Indicateur_prop.Ncontamination_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ncontaminant_Jussieu_$rank") ;
    save_indicators(Propagation.Indicateur_prop.Ngueri_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ngueri_Jussieu_$rank") ;
    save_indicators(Propagation.Indicateur_prop.Incidence_biais,"Res/$(lpad(Propagation.name_folder,1))/txt_file/IncidenceB_Jussieu_$rank") ;

    if(rank == 0)
        if(ParamFile.CSV_PARAM)
            write_CSV(Propagation.name_folder)
        end
    end


end

function save_txtfile(Propagation::Simulateur)

    ### Sauvegarde des indicateurs bruts
    save_indicators(Propagation.Indicateur_prop.Ntotal_cont_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ntotal_cont_Jussieu") ;
    save_indicators(Propagation.Indicateur_prop.Ntotal_sain_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ntotal_sain_Jussieu") ;
    save_indicators(Propagation.Indicateur_prop.Nnew_cont_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Nnew_cont_Jussieu") ;
    save_indicators(Propagation.Indicateur_prop.Ncontamination_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ncontaminant_Jussieu") ;
    save_indicators(Propagation.Indicateur_prop.Ngueri_MC,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Ngueri_Jussieu") ;
    save_indicators(Propagation.Indicateur_prop.Incidence_biais,"Res/$(lpad(Propagation.name_folder,1))/txt_file/IncidenceB_Jussieu") ;

    ### Calcul des intervalles de confiance
    Interval_NtotCont = confidence_interval(Propagation.Indicateur_prop.Ntotal_cont_MC) ;
    Interval_NtotSain = confidence_interval(Propagation.Indicateur_prop.Ntotal_sain_MC) ;
    Interval_NnewCont = confidence_interval(Propagation.Indicateur_prop.Nnew_cont_MC) ;
    Interval_Ncontam  = confidence_interval(Propagation.Indicateur_prop.Ncontamination_MC) ;
    Interval_Ngueri   = confidence_interval(Propagation.Indicateur_prop.Ngueri_MC) ;
    Interval_IncidenceB = confidence_interval(Propagation.Indicateur_prop.Incidence_biais) ;
    ###
    save_indicators(Interval_NtotCont,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Interval_NtotCont_Jussieu") ;
    save_indicators(Interval_NtotSain,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Interval_NtotSain_Jussieu") ;
    save_indicators(Interval_NnewCont,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Interval_NnewCont_Jussieu") ;
    save_indicators(Interval_Ncontam, "Res/$(lpad(Propagation.name_folder,1))/txt_file/Interval_Ncontam_Jussieu") ;
    save_indicators(Interval_Ngueri,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Interval_Ngueri_Jussieu") ;
    save_indicators(Interval_IncidenceB,"Res/$(lpad(Propagation.name_folder,1))/txt_file/Interval_IncidenceB_Jussieu") ;

    return()

end





function write_CSV(name_folder::String)

    if(isfile("Data/parameter_simulation.csv"))
        update_CSV(name_folder)
    else
        println("The CSV file does not exist - We create a new file in Data/ folder")
        create_CSV(name_folder)
    end

end


function create_CSV(name_folder::String)

    r = readdlm("Res/$(lpad(name_folder,1))/Input_Data.txt")
    df = DataFrame(r[1,1] => r[1,2])

    for i=2:size(r,1)
        insertcols!(df,i,r[i,1]=>r[i,2])
    end

    insertcols!(df,size(r,1)+1,:NameFolder => name_folder)

    CSV.write("Data/parameter_simulation.csv", df)

end


function update_CSV(name_folder::String)

    r = readdlm("Res/$(lpad(name_folder,1))/Input_Data.txt")
    df = DataFrame(CSV.File("Data/parameter_simulation.csv"))

    t = r[:,2] ;
    push!(t,name_folder) ;
    push!(df,t)

    CSV.write("Data/parameter_simulation.csv", df)

end


function interval_file(name_folder,nbproc)

    res_total_cont = [] ;
    res_sain_cont = [] ;
    res_new_cont = [] ;
    res_contamination = [] ;
    res_gueri = [] ;
    res_biais = [] ;

    for i = 0:nbproc-1

        Ntotal_cont_MC = readdlm("Res/$(lpad(name_folder,1))/txt_file/Ntotal_cont_Jussieu_$i.txt") ;
        Ntotal_sain_MC = readdlm("Res/$(lpad(name_folder,1))/txt_file/Ntotal_sain_Jussieu_$i.txt") ;
        Nnew_cont_MC   = readdlm("Res/$(lpad(name_folder,1))/txt_file/Nnew_cont_Jussieu_$i.txt") ;
        Ncontamination_MC = readdlm("Res/$(lpad(name_folder,1))/txt_file/Ncontaminant_Jussieu_$i.txt") ;
        Ngueri_MC = readdlm("Res/$(lpad(name_folder,1))/txt_file/Ngueri_Jussieu_$i.txt") ;
        Nbiais_MC = readdlm("Res/$(lpad(name_folder,1))/txt_file/IncidenceB_Jussieu_$i.txt") ;

        for j = 1:size(Ntotal_cont_MC,2)
            append!(res_total_cont,Ntotal_cont_MC[:,j]) ;
            append!(res_sain_cont,Ntotal_sain_MC[:,j]) ;
            append!(res_new_cont, Nnew_cont_MC[:,j]) ;
            append!(res_contamination,Ncontamination_MC[:,j]) ;
            append!(res_gueri,Ngueri_MC[:,j]) ;
            append!(res_biais,Nbiais_MC[:,j]) ;
        end

    end

    res1 = reshape(res_total_cont,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res2 = reshape(res_sain_cont,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res3 = reshape(res_new_cont,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res4 = reshape(res_contamination,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res5 = reshape(res_gueri,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res6 = reshape(res_biais,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;

    res1_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res2_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res3_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res4_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res5_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res6_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;

    @inbounds for i = 1:ParamSimu.NB_DAY+1

        res1_1[i,1] = quantile(res1[i,:],0.1) ;
        res1_1[i,2] = mean(res1[i,:]) ;
        res1_1[i,3] = quantile(res1[i,:],0.9) ;

        res2_1[i,1] = quantile(res2[i,:],0.1) ;
        res2_1[i,2] = mean(res2[i,:]) ;
        res2_1[i,3] = quantile(res2[i,:],0.9) ;

        res3_1[i,1] = quantile(res3[i,:],0.1) ;
        res3_1[i,2] = mean(res3[i,:]) ;
        res3_1[i,3] = quantile(res3[i,:],0.9) ;

        res4_1[i,1] = quantile(res4[i,:],0.1) ;
        res4_1[i,2] = mean(res4[i,:]) ;
        res4_1[i,3] = quantile(res4[i,:],0.9) ;

        res5_1[i,1] = quantile(res5[i,:],0.1) ;
        res5_1[i,2] = mean(res5[i,:]) ;
        res5_1[i,3] = quantile(res5[i,:],0.9) ;

        res6_1[i,1] = quantile(res6[i,:],0.1) ;
        res6_1[i,2] = mean(res6[i,:]) ;
        res6_1[i,3] = quantile(res6[i,:],0.9) ;


    end

    f = writedlm("Res/$(lpad(name_folder,1))/txt_file/BilanTotal.txt", [res1_1 res2_1 res3_1 res4_1 res5_1 res6_1])

end


function save_jsonfile_MPI(Propagation::Simulateur,rank::Int)

    save_indicators_jsonfile(Propagation.Indicateur_prop.Ntotal_cont_MC,"Res/$(lpad(Propagation.name_folder,1))/json_file/Ntotal_cont_Jussieu_$rank") ;
    save_indicators_jsonfile(Propagation.Indicateur_prop.Ntotal_sain_MC,"Res/$(lpad(Propagation.name_folder,1))/json_file/Ntotal_sain_Jussieu_$rank") ;
    save_indicators_jsonfile(Propagation.Indicateur_prop.Nnew_cont_MC,"Res/$(lpad(Propagation.name_folder,1))/json_file/Nnew_cont_Jussieu_$rank") ;
    save_indicators_jsonfile(Propagation.Indicateur_prop.Incidence_biais,"Res/$(lpad(Propagation.name_folder,1))/json_file/IncidenceB_Jussieu_$rank") ;
    save_indicators_jsonfile(Propagation.Indicateur_prop.Ncontamination_MC,"Res/$(lpad(Propagation.name_folder,1))/json_file/Ncontaminant_Jussieu_$rank") ;
    save_indicators_jsonfile(Propagation.Indicateur_prop.Ngueri_MC,"Res/$(lpad(Propagation.name_folder,1))/json_file/Ngueri_Jussieu_$rank") ;

end


function interval_file_json(name_folder,nbproc)

    res_total_cont = [] ;
    res_sain_cont = [] ;
    res_new_cont = [] ;
    res_contamination = [] ;
    res_gueri = [] ;
    res_biais = [] ;

    for i = 0:nbproc-1

        dictNc = JSON.parsefile("Res/$(lpad(name_folder,1))/json_file/Ntotal_cont_Jussieu_$i.json") ;
        dictNs = JSON.parsefile("Res/$(lpad(name_folder,1))/json_file/Ntotal_sain_Jussieu_$i.json") ;
        dictNnc = JSON.parsefile("Res/$(lpad(name_folder,1))/json_file/Nnew_cont_Jussieu_$i.json") ;
        dictNncb = JSON.parsefile("Res/$(lpad(name_folder,1))/json_file/IncidenceB_Jussieu_$i.json") ;
        dictNct = JSON.parsefile("Res/$(lpad(name_folder,1))/json_file/Ncontaminant_Jussieu_$i.json") ;
        dictNg = JSON.parsefile("Res/$(lpad(name_folder,1))/json_file/Ngueri_Jussieu_$i.json") ;

        for j = 1:ParamSimu.NB_MC
            append!(res_total_cont,dictNc["x"][j]) ;
            append!(res_sain_cont,dictNs["x"][j]) ;
            append!(res_new_cont,dictNnc["x"][j] ) ;
            append!(res_contamination,dictNct["x"][j]) ;
            append!(res_gueri,dictNg["x"][j]) ;
            append!(res_biais,dictNncb["x"][j]) ;
        end

    end

    res1 = reshape(res_total_cont,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res2 = reshape(res_sain_cont,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res3 = reshape(res_new_cont,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res4 = reshape(res_contamination,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res5 = reshape(res_gueri,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;
    res6 = reshape(res_biais,(ParamSimu.NB_DAY+1,nbproc*ParamSimu.NB_MC)) ;

    res1_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res2_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res3_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res4_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res5_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;
    res6_1 = zeros(Float64,(ParamSimu.NB_DAY+1,3)) ;

    for i = 1:ParamSimu.NB_DAY+1

        res1_1[i,1] = quantile(res1[i,:],0.1) ;
        res1_1[i,2] = mean(res1[i,:]) ;
        res1_1[i,3] = quantile(res1[i,:],0.9) ;

        res2_1[i,1] = quantile(res2[i,:],0.1) ;
        res2_1[i,2] = mean(res2[i,:]) ;
        res2_1[i,3] = quantile(res2[i,:],0.9) ;

        res3_1[i,1] = quantile(res3[i,:],0.1) ;
        res3_1[i,2] = mean(res3[i,:]) ;
        res3_1[i,3] = quantile(res3[i,:],0.9) ;

        res4_1[i,1] = quantile(res4[i,:],0.1) ;
        res4_1[i,2] = mean(res4[i,:]) ;
        res4_1[i,3] = quantile(res4[i,:],0.9) ;

        res5_1[i,1] = quantile(res5[i,:],0.1) ;
        res5_1[i,2] = mean(res5[i,:]) ;
        res5_1[i,3] = quantile(res5[i,:],0.9) ;

        res6_1[i,1] = quantile(res6[i,:],0.1) ;
        res6_1[i,2] = mean(res6[i,:]) ;
        res6_1[i,3] = quantile(res6[i,:],0.9) ;


    end

    x = float([0:1:ParamSimu.NB_DAY;]) ;

    id = ["Ncont","Ncontp","Ncontm","Nsain","Nsainm","Nsainp","Nnewcont",
    "Nnewcontp","Nnewcontm","Nbiais","Nbiaisp","Nbiaism","Ncontamin","Ncontaminp","Ncontaminm",
    "Ngueri","Nguerip","Nguerim"] ;

    B = Dict("x"=>x) ;
    push!(B,"$(id[1])"=>res1_1[:,2]) ;
    push!(B,"$(id[2])"=>res1_1[:,3]) ;
    push!(B,"$(id[3])"=>res1_1[:,1]) ;
    push!(B,"$(id[4])"=>res2_1[:,2]) ;
    push!(B,"$(id[5])"=>res2_1[:,3]) ;
    push!(B,"$(id[6])"=>res2_1[:,1]) ;
    push!(B,"$(id[7])"=>res3_1[:,2]) ;
    push!(B,"$(id[8])"=>res3_1[:,3]) ;
    push!(B,"$(id[9])"=>res3_1[:,1]) ;
    push!(B,"$(id[10])"=>res6_1[:,2]) ;
    push!(B,"$(id[11])"=>res6_1[:,3]) ;
    push!(B,"$(id[12])"=>res6_1[:,1]) ;
    push!(B,"$(id[13])"=>res4_1[:,2]) ;
    push!(B,"$(id[14])"=>res4_1[:,3]) ;
    push!(B,"$(id[15])"=>res4_1[:,1]) ;
    push!(B,"$(id[16])"=>res5_1[:,2]) ;
    push!(B,"$(id[17])"=>res5_1[:,3]) ;
    push!(B,"$(id[18])"=>res5_1[:,1]) ;

    j= JSON.json(B) ;

    open("Res/$(lpad(name_folder,1))/json_file/BilanTotal.json","w") do f
        write(f, j)
    end

end