include("cia.jl")

prods = Dict(:Products => cia)
nyl_fias = Dict(:New_York_Life => merge(Dict(:Comdex => 100), prods))
