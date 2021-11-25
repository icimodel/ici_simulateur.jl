var documenterSearchIndex = {"docs":
[{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"DocTestSetup  = quote\n    using ICI_simulateur\nend","category":"page"},{"location":"index.html#ICI_simulateur-1","page":"ICI_simulateur","title":"ICI_simulateur","text":"","category":"section"},{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"Documentation goes here.","category":"page"},{"location":"index.html#Example-blocks-1","page":"ICI_simulateur","title":"Example blocks","text":"","category":"section"},{"location":"index.html#Script:-@example-1","page":"ICI_simulateur","title":"Script: @example","text":"","category":"section"},{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"import Random   # hide\nRandom.seed!(1) # hide\nA = rand(3, 3)\nb = [1, 2, 3]\nA \\ b","category":"page"},{"location":"index.html#REPL:-@repl-1","page":"ICI_simulateur","title":"REPL: @repl","text":"","category":"section"},{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"1 + 1","category":"page"},{"location":"index.html#Documentation-tests-1","page":"ICI_simulateur","title":"Documentation tests","text":"","category":"section"},{"location":"index.html#Script-1","page":"ICI_simulateur","title":"Script","text":"","category":"section"},{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"a = 1\nb = 2\na + b\n\n# output\n\n3","category":"page"},{"location":"index.html#REPL-1","page":"ICI_simulateur","title":"REPL","text":"","category":"section"},{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"julia> a = 1\n1\n\njulia> b = 2;\n\njulia> c = 3;  # comment\n\njulia> a + b + c\n6","category":"page"},{"location":"index.html#Reference-1","page":"ICI_simulateur","title":"Reference","text":"","category":"section"},{"location":"index.html#@autodocs-1","page":"ICI_simulateur","title":"@autodocs","text":"","category":"section"},{"location":"index.html#","page":"ICI_simulateur","title":"ICI_simulateur","text":"Modules = [ICI_simulateur]\nOrder   = [:function, :type]","category":"page"},{"location":"index.html#ICI_simulateur.Principal-Tuple{}","page":"ICI_simulateur","title":"ICI_simulateur.Principal","text":"Function Principal  Fonction principale du simulateur. Permet de lancer les simulations de propagation d'épidémies sur une région donnée.  C'est cette fonction qu'il faut appeler dans le programme principal\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.choix_step-Tuple{Int64, Int32, ICI_simulateur.Statut_covid}","page":"ICI_simulateur","title":"ICI_simulateur.choix_step","text":"Function JourneeIndiv_trace\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.contamination_direct-Tuple{Float64, Float64, Float64, Float64, Float64, Int32, Int64, Int32, Int32}","page":"ICI_simulateur","title":"ICI_simulateur.contamination_direct","text":"ContaminationDirect(depc,deps,arrc,arrs,proba)\n\n# Function used to compute the contamination\n# Input:\n# - depc:\n# - deps:\n# - arrc:\n# - arrs:\n# - proba:\n# Output:\n# - p\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.contamination_externe!-Tuple{ICI_simulateur.Statut_covid, Vector{Float64}, Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.contamination_externe!","text":"Function Contaminationexterne! #Fonction permettant de calculer la contamination ayant lieu à l'extérieur du domaine #Entrées : #- statcovid::Statutcovid, #- incidence::Array{Float64,1} #- statut::Array{Int32,1} #- indivinout::Array{Int32,1} #- whereis_local::Array{Any,1} #Sorties :\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.contamination_fct!-Tuple{ICI_simulateur.Statut_covid, Vector{Int32}, Int64, DefJournee, Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.contamination_fct!","text":"Fonction Contamination_fct! #Fonction calculant la contamination au sein du quartier\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.def_parametre_input-Tuple{Any, String}","page":"ICI_simulateur","title":"ICI_simulateur.def_parametre_input","text":"DefParametreInput(namefolder,namefile_graph)\n\nFunction used to define a file with all of the input data used in the modeling.\nThis function creates a txt file named Input_Data.txt\n\nInput:\n- name_folder::String (name of the folder where the file is created)\n- name_file_graph::String (name of the graph used in the modeling)\nOutput:\n- NaN\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.deplacement_v2!-Tuple{DefJournee, City, Population, ICI_simulateur.Statut_covid}","page":"ICI_simulateur","title":"ICI_simulateur.deplacement_v2!","text":"Function Deplacement_v2!\n\nFonction permettant de définir les déplacements des individus sur toute une journée. Cette journée est différente selon le statut des individus. Si une mesure sanitaire est mise en place, alors cette journée est impactée.\n\nEntrées :\n\nJour : Structure DefJournee à mettre à jour\nVille : Structure City contenant les informations sur les lieux et bâtiments\nIndividu : Structure Population contenant les informations sur les individus\nstatcovid : Structure Statut_covid contenant les informations sur la covid\n\nSortie :\n\nJour : Structure Jour contenant les lieux visités par les individus\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.journee_indiv-Tuple{Int64, City, Population, ICI_simulateur.Statut_covid}","page":"ICI_simulateur","title":"ICI_simulateur.journee_indiv","text":"Function journee_indiv Fonction permettant de définir la journée d'un individu.\n\nEntrées :\n\ni_indiv : Indice de l'individu\nVille : Structure City contenant les informations sur les lieux et bâtiments\nIndividu : Structure Population contenant les informations sur les individus\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.mise_a_jour!-Tuple{ICI_simulateur.Statut_covid, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.mise_a_jour!","text":"miseajour!(contamination0,contamination1,p_covid,cpt)\n\n# Function used to update the contamination at the end of the day\n# Input:\n# - contamination0:\n# - contamination1:\n# - p_covid:\n# - cpt:\n# Output :\n# - NO OUTPUT\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.mise_en_place!-Tuple{ICI_simulateur.Statut_covid, Int32}","page":"ICI_simulateur","title":"ICI_simulateur.mise_en_place!","text":"Function MiseEnPlace! #Fonction permettant de mettre en place des mesures sanitaires #Entrées : #- statcovid::Statut_covid #- indicateur::Int32 #Sorties :\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.miseajour_mesure!-Tuple{ICI_simulateur.Statut_covid, Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.miseajour_mesure!","text":"Function miseajour_mesure!\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.parallelisation-Tuple{}","page":"ICI_simulateur","title":"ICI_simulateur.parallelisation","text":"Parallelisation()\n\nFunction used to define the parallelization. The function returns the rank of the processus\n\nInput:\n- NaN\nOutput:\n- comm\n- rank::Int\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.DefJournee","page":"ICI_simulateur","title":"ICI_simulateur.DefJournee","text":"Struct DefJournee #Structure contenant les informations des déplacements des individus (identifiant du lieu, heure d'arrivée et heure de départ)\n\n\n\n\n\n","category":"type"},{"location":"index.html#ICI_simulateur.Simulateur","page":"ICI_simulateur","title":"ICI_simulateur.Simulateur","text":"Struct Simulateur \n\n\n\n\n\n","category":"type"},{"location":"index.html#ICI_simulateur.choix_resto-Tuple{Vector{Float64}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.choix_resto","text":"Function choix_resto \n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.choix_travail-Tuple{Vector{Int32}, Vector{Int32}, Vector{Int32}, Vector{Float64}}","page":"ICI_simulateur","title":"ICI_simulateur.choix_travail","text":"Function ChoixTravail  #Fonction permettant d'associer une entreprise à un individu ainsi que le tissu social (~collègues proches) #Entrées :  #- statut::Array{Int32,1} #- indivinout::Array{Int32,1} #- idwork::Array{Int32,1} #- areawork::Array{Float64,1} #Sorties :  #- idindwork::Array{Int32,1} #- tissu_work::Array{Int32,1}\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.compute_indicateur!-Tuple{Indicateur, Int64, Int64, Vector{Int32}, Vector{Int32}, Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.compute_indicateur!","text":"function Compute_Indicateur  #Fonction permettant de calculer les indicateurs épidémiologiques \n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.confidence_interval-Tuple{Any}","page":"ICI_simulateur","title":"ICI_simulateur.confidence_interval","text":"Confidence_interval(resultat,alpha)\n\n# Function used to compute the confidence interval of each parameter\n# of the modeling\n# Input:\n# - resultat:\n# - alpha: alpha-confidence\n# Output:\n# - Interv: Matri containing the confidence interval of the indicator\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.covid_identite-Tuple{}","page":"ICI_simulateur","title":"ICI_simulateur.covid_identite","text":"Covid_Identite()\n\n# Function used to define the parameters associated to the Covid for each individual\n# Input:\n# NO INPUT\n# Output:\n# - tps_incub ({Int32}): incubation time (expressed in day)\n# - tps_dt_cont ({Int32}):\n# - proba ({Float64}): probability of contamination (between 0 and 1)\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.def_indiv_in-Tuple{Vector{Int32}, Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.def_indiv_in","text":"Function IndivIn  #Fonction permettant de mettre en place les individus qui entrent pour travailler au sein du quartier  #Entrées :  #- indivout::Array{Int32,1} #- statut::Array{Int32,1} #- idhouse::Array{Int32,1} #Sorties :  #- indivinout::Array{Int32,1} #- statut::Array{Int32,1} #- idhouse::Array{Int32,1} \n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.def_indiv_out-Tuple{Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.def_indiv_out","text":"Function IndivOut #Fonction permettant de mettre en place les individus qui sortent pour travailler en dehors du quartier  #Entrée :  #- statut::Array{Int32,1} #Sorties :  #- indivout::Array{Int32,1}\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.def_statut-Tuple{Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.def_statut","text":"Function DefStatut  #Fonction permettant de définir les statuts sociales des individus : actif, étudiant, écolier, retraité  #Entrées :  #- cat_age::Array{Int32,1} #Sorties : #- statut::Array{Int32,1}\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.distance_resto-Tuple{Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.distance_resto","text":"Function DistanceResto Fonction permettant de définir la distance la plus courte entre une entreprise et l'ensemble des services de restaurations.\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.distribution_workingplace-Tuple{Vector{Int64}, Vector{Int32}, Vector{Float64}}","page":"ICI_simulateur","title":"ICI_simulateur.distribution_workingplace","text":"Function RepartitionEntreprise  #Fonction permettant de repartir les individus au sein des entreprises  #Entrées :  #- actif::Array{Int64,1} #- idwork::Array{Int32,1} #- areawork::Array{Float64,1} #Sorties :  #- Repartition::Array{Int64,1}\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.heure_indiv-Tuple{Int32}","page":"ICI_simulateur","title":"ICI_simulateur.heure_indiv","text":"Function heure_indiv \n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.indiv_inout-Tuple{Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.indiv_inout","text":"Function IndivInOut  #Fonction permettant de mettre en place les individus entrant et sortant du quariter  #Entrées :  #- statut::Array{Int32,1} #- idhouse::Array{Int32,1} #Sorties :  #- indivinout::Array{Int32,1} #- statut::Array{Int32,1} #- id_house::Array{Int32,1}\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.individual-Tuple{MetaGraphs.MetaGraph, Int64}","page":"ICI_simulateur","title":"ICI_simulateur.individual","text":"Individual(graph, n_node)\n\n# Function used to find the id node of all individuals\n# Input:\n# - graph: undirected Int64 metagraph with Float64 weights\n# - n_node ({Int32}): total number of nodes\n# Output:\n# - id_indiv (Array{Int32,.}): Vector containing the id of all individuals\n# - id_house (Array{Int32,.}): Vector containing the id of the corresponding house\n# - cat_age (Array{Int32,.}): Vector containing the age category\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.miseajour_tracage!-Tuple{ICI_simulateur.Statut_covid, Vector{Int32}, Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.miseajour_tracage!","text":"Function miseajour_tracage!\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.poi-Tuple{MetaGraphs.MetaGraph, Int64}","page":"ICI_simulateur","title":"ICI_simulateur.poi","text":"POI(graph, n_node)\n\nFunction used to find the id node of all POI\nInput:\n- graph: undirected Int64 metagraph with Float64 weights\n- n_node ({Int32}): total number of nodes\nOutput:\n- id_poi (Array{Int32,.}): Vector containing the id of all POI\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.proba_restaurant-Tuple{}","page":"ICI_simulateur","title":"ICI_simulateur.proba_restaurant","text":"Function proba_restaurant()  Fonction permettant de définir une probabilité liée à la distance entre le restaurant et l'entreprise\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.save_indicators-Tuple{Any, String}","page":"ICI_simulateur","title":"ICI_simulateur.save_indicators","text":"Saveindicators(resultat,namefile)\n\n# Function used to write the result of the modeling into a txt file\n# Input:\n# - resultat:\n# - name_file: name of the file\n# Output :\n# NO OUTPUT\n\n# This function needs the library DelimitedFiles\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.save_indicators_jsonfile-Tuple{Any, String}","page":"ICI_simulateur","title":"ICI_simulateur.save_indicators_jsonfile","text":"Saveindicatorsjson(resultat,name_file)\n\n# Function used to write the result of the modeling into a txt file\n# Input:\n# - resultat:\n# - name_file: name of the file\n# Output :\n# NO OUTPUT\n\n# This function needs the library JSON\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.tissu-Tuple{Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.tissu","text":"Function Tissu \n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.tissu_social-Tuple{Vector{Int32}}","page":"ICI_simulateur","title":"ICI_simulateur.tissu_social","text":"Function Tissu_social  #Fonction permettant de mettre en place un tissu social au sein de l'entreprise. Ce sont des personnes qui seront plus proches entre eux.  #Entrées :  #- Structure::Array{Int32,1} #Sorties :  #- Structure::Array{Int32,1}\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.working_place-Tuple{MetaGraphs.MetaGraph, Int64}","page":"ICI_simulateur","title":"ICI_simulateur.working_place","text":"WorkingPlace(graph, n_node)\n\nFunction used to find the id node of all working place\nInput:\n- graph: undirected Int64 metagraph with Float64 weights\n- n_node ({Int32}): total number of nodes\nOutput:\n- id_work (Array{Int32,.}): Vector containing the id of all working place\n- area_work (Array{Int32,.}): Vector containing the area of each working place\n\n\n\n\n\n","category":"method"},{"location":"index.html#ICI_simulateur.Statut_covid","page":"ICI_simulateur","title":"ICI_simulateur.Statut_covid","text":"mutable struct Statut_Covid #Structure contenant les paramètres épidémiologiques du modèle\n\n\n\n\n\n","category":"type"}]
}