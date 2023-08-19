#Withdrawals
ages = collect(50:1:80)
deferrals = collect(1:1:12)

ws = Dict(ages .=> collect(0.053:0.001:0.083))

jdiff = 0.005
rdiff = 0.02
incs = Dict(ages .=> collect(0.003:0.0001:0.006))

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

location = Dict(:Location => :Withdrawal)
mins = Dict(:Minimums => Dict(:Deferral => 10))
maxes = Dict(:Maximums => Dict(:Age => 84))
inc_type = Dict(:Income_Types => merge(Dict(:Level => :Level), Dict(:Rising => :Rising)))
params = Dict(:Paramaters => merge(location, mins, maxes, inc_type))
income_rider = Dict(:Rider => merge(ws, params))

val_keys = [:Strategy_Name, :Struct_Type, :Risk_Profile, :Period, :Asset_Class, :Cap, :Floor]
p2p_vals = [:Point_to_Point, :Multiplier, :Conservative, 1, :SNP_500, 0.065, 0.0]
fix_vals = [:Fixed, :Fixed, :Very_Conservative, 1, :SNP_500, 0.034, 0.034]
p2p = Dict(val_keys .=> p2p_vals)
fix = Dict(val_keys .=> fix_vals)

strategies = Dict(:Strategies => [p2p, fix])

#Fees
surrender = Dict(:Surrender => [0.1, 0.1, 0.1, 0.0875, 0.075, 0.0625, 0.05, 0.0375, 0.025, 0.0125])
fees = Dict(:Fees => merge(Dict(:Rider => 0.013), surrender))

#Benefits
multiplier = Dict(:Multiplier => merge(Dict(:Rate => 1.25), Dict(:Term => :Deferral)))

bonus = Dict(:Bonus => 1.25)
benefit = Dict(:Benefit => merge(bonus, multiplier))

#Benefits
multiplier = Dict(:Multiplier => 1.25)
benefit = Dict(:Benefit => Dict(:Options => Dict(:Multiplier => multiplier)))

alz_360 = Dict(Symbol(360) => merge(benefit, income_rider, strategies, fees))

export alz_360