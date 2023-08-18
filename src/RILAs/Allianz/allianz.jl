include("iapi.jl")

prods = Dict(:Products => iapi)

alz_rilas = Dict(:Allianz => merge(Dict(:Comdex => 97), prods))