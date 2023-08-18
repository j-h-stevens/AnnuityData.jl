#Withdrawals
ages = collect(50:1:80)
deferrals = collect(1:1:12)

ws = Dict(ages .=> collect(0.048:0.001:0.078))

jdiff = 0.005
rdiff = 0.011

incs = Dict(ages .=> zeros(length(ages)))
[incs[i] = 0.0045 for i in collect(50:1:54)]
[incs[i] = 0.005 for i in collect(55:1:59)]
[incs[i] = 0.0055 for i in collect(60:1:64)]
[incs[i] = 0.006 for i in collect(65:1:69)]
[incs[i] = 0.0065 for i in collect(70:1:74)]
[incs[i] = 0.007 for i in collect(75:1:79)]
[incs[i] = 0.0075 for i in collect(80:1:100)]

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
snp_p2p = [:Point_to_Point, :Multiplier, :Conservative, 1, :SNP_500, 0.07, 0.0]
russ_p2p = [:Point_to_Point, :Multiplier, :Conservative, 1, :Russell_2000, 0.07, 0.0]
nas_p2p = [:Point_to_Point, :Multiplier, :Conservative, 1, :Nasdaq_100, 0.07, 0.0]
fix_vals = [:Fixed, :Fixed, :Very_Conservative, 1, :SNP_500, 0.04, 0.04]
snp_p2p = Dict(val_keys .=> snp_p2p)
russ_p2p = Dict(val_keys .=> russ_p2p)
nas_p2p = Dict(val_keys .=> nas_p2p)

fix = Dict(val_keys .=> fix_vals)

strategies = Dict(:Strategies => [snp_p2p, russ_p2p, nas_p2p, fix])

#Fees
surrender = Dict(:Surrender => [0.085, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03])
fees = Dict(:Fees => merge(Dict(:Contract => 0.0125), surrender))

#Product
prod_type = Dict(:Growth_Type => :Account)
alz_cy7 = Dict(:Core_Income_7 => merge(prod_type, income_rider, strategies, fees))

export alz_cy7