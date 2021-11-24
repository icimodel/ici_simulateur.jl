using Pkg
using PackageCompiler
using ICI_simulateur

cd("ICI_simulateur/src")

create_sysimage(
    # Liste des paquets à inclure dans l'image système
    [:ICI_simulateur],

    # Chemin de l'image générée
    #sysimage_path = "ICI_simulateur.so",

    # Script de précompilation
    precompile_execution_file = "run_for_precompile.jl",
    #joinpath(@__DIR__, "test", "runtests.jl"),

    # Ligne à ajouter pour générer une image système "portable" pour
    # toutes les architectures x86-64
    #cpu_target = "generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"
)
