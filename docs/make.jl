push!(LOAD_PATH,joinpath(@__DIR__, ".."))
using Documenter, ICI_simulateur

makedocs(
    modules = [ICI_simulateur],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Nicolas GILET",
    sitename = "ICI_simulateur.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "framagit.org/ici/ICI_simulateur.jl.git",
)
