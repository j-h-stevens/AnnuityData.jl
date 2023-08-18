include("ric.jl")

prods = Dict(:Products => ric)

tf_vas = Dict(:Thrivent_Financial => merge(Dict(:Comdex => 100), prods))