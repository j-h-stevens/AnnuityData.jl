include("222.jl")
include("360.jl")
include("benefit_control.jl")
include("core_income_7.jl")
include("retirement_foundation_adv.jl")
include("222.jl")

prods = Dict(:Products => merge(alz_222, alz_360, alz_bc, alz_cy7, alz_rf))

alz_fias = Dict(:Allianz => merge(Dict(:Comdex => 97), prods))