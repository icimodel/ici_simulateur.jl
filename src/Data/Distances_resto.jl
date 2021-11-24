
function DistanceResto(id_aliment,id_work)


    simple_graph = loadgraph("SaintVicNoChildrenLeftBehind.graphml", GraphIO.GraphML.GraphMLFormat()) ;


    chemin = zeros(Int32,(length(id_work),length(id_aliment))) ;


    @time @threads for i = 1:length(id_work)
        for j=1:length(id_aliment)
            ch = a_star(simple_graph,id_work[i],id_aliment[j]) ;
            chemin[i,j] = length(ch) ;
        end

        println("J\'ai fini la",i,"eme entreprise")

    end


    return(chemin)

end


DistanceResto
