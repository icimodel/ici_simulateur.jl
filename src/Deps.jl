#!/usr/bin/env julia

using Pkg

Pkg.generate("ICI_simulateur")
Pkg.activate("ICI_simulateur")

Pkg.add(Pkg.PackageSpec(;name="CSV", version="0.9.9"))
Pkg.add(Pkg.PackageSpec(;name="JSON", version="0.21.2"))
Pkg.add(Pkg.PackageSpec(;name="DataFrames", version="1.2.2"))
Pkg.add(Pkg.PackageSpec(;name="Distributions", version="0.25.22"))
Pkg.add(Pkg.PackageSpec(;name="GraphIO", version="0.6.0"))
Pkg.add(Pkg.PackageSpec(;name="LightGraphs", version="1.3.5"))
Pkg.add(Pkg.PackageSpec(;name="MetaGraphs", version="0.6.6"))
Pkg.add(url="https://github.com/zhangliye/GraphMLReader.jl")
Pkg.add(Pkg.PackageSpec(;name="MPI", version="0.19.1"))
Pkg.add(Pkg.PackageSpec(;name="SpecialFunctions", version="1.8.1"))
Pkg.add(Pkg.PackageSpec(;name="StatsBase", version="0.33.12"))
Pkg.add(Pkg.PackageSpec(;name="PackageCompiler", version="1.4.1"))
Pkg.add(Pkg.PackageSpec(;name="Statistics"))
Pkg.add(Pkg.PackageSpec(;name="TimerOutputs"))
Pkg.add(Pkg.PackageSpec(;name="Random"))
Pkg.add(Pkg.PackageSpec(;name="Dates"))
Pkg.add(Pkg.PackageSpec(;name="DelimitedFiles"))
