#Withdrawals
ages = collect(50:1:80)
deferrals = collect(1:1:12)

ws = Dict(ages .=> collect(0.053:0.001:0.083))

jdiff = 0.005
rdiff = 0.011

incs = Dict(ages .=> collect(0.0045:0.0001:0.0075))

function withdrawals(ws::Dict{Int64, Float64}, deferrals::Vector{Int64}, incs::Dict{Int64, Float64})
    age_vals = []
    for (ak, av) ∈ ws
        def_vals = []
        for def ∈ deferrals
            push!(def_vals, Dict(def => round(av + incs[ak] * def,digits=3)))
        end
        push!(age_vals, Dict(ak => reduce(merge, def_vals)))
    end
    return reduce(merge, age_vals)
end


sl = withdrawals(ws, deferrals, incs)
jl = withdrawals(Dict(ages .=> Float64.(values(ws)) .- jdiff), deferrals, incs)
sr = withdrawals(Dict(ages .=> Float64.(values(ws)) .- rdiff), deferrals, incs)
jr = withdrawals(Dict(ages .=> Float64.(values(ws)) .- (rdiff+jdiff)), deferrals, incs)

level = Dict(:Level => merge(Dict(:Single => sl), Dict(:Joint => jl)))
rise = Dict(:Rising => merge(Dict(:Single => sr), Dict(:Joint => jr)))
ws = Dict(:Withdrawals => merge(level, rise))

location = Dict(:Location => :Issue)
mins = Dict(:Minimums => Dict(:Deferral => 1))
maxes = Dict(:Maximums => Dict(:Age => 84))
inc_type = Dict(:Income_Types => merge(Dict(:Level => :Level), Dict(:Rising => :Rising)))
params = Dict(:Paramaters => merge(location, mins, maxes, inc_type))
income_rider = Dict(:Rider => merge(ws, params))

val_keys = [:Strategy_Name, :Struct_Type, :Risk_Profile, :Period, :Asset_Class, :Cap, :Floor]
snp_p2p = [:Point_to_Point, :Multiplier, :Conservative, 1, :SNP_500, 0.075, 0.0]
russ_p2p = [:Point_to_Point, :Multiplier, :Conservative, 1, :Russell_2000, 0.075, 0.0]
nas_p2p = [:Point_to_Point, :Multiplier, :Conservative, 1, :Nasdaq_100, 0.075, 0.0]
fix_vals = [:Fixed, :Fixed, :Very_Conservative, 1, :SNP_500, 0.043, 0.043]
snp_p2p = Dict(val_keys .=> snp_p2p)
russ_p2p = Dict(val_keys .=> russ_p2p)
nas_p2p = Dict(val_keys .=> nas_p2p)

fix = Dict(val_keys .=> fix_vals)

strategies = Dict(:Strategies => [snp_p2p, russ_p2p, nas_p2p, fix])

#Fees
surrender = Dict(:Surrender => [0.065, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01])
fees = Dict(:Fees => merge(Dict(:Contract => 0.0125), surrender))

#Product
prod_type = Dict(:Growth_Type => :Account)
alz_rf = Dict(:Retirement_Foundation_ADV => merge(prod_type, income_rider, strategies, fees))

export alz_rf