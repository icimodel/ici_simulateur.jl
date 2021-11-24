

mutable struct Mesures

    deb_mesure::Array{Int32,1} ;
    temps_mesure::Array{Int32,1} ;


    function Mesures(nb_pop::Int32)

        deb_mesure = zeros(Int32,nb_pop) ;
        temps_mesure = zeros(Int32,nb_pop) ;

        if(mesures.tracage)
            deb_mesure .= Trace.delai_trace ;
            temps_mesure .= Trace.jours_conf ;
        end

        return new(deb_mesure,temps_mesure)


    end


end
