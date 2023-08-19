#Withdrawals
ages = collect(50:1:80)
deferrals = collect(10:1:12)

sixty = Dict(69 => 0.05)
seventy = Dict(79 => 0.055)
eighty = Dict(80 => 0.06)

s = reduce(merge, [Dict(age => reduce(merge, [Dict(def => 0.0) for def ∈ deferrals])) for age ∈ ages])

for (ak, av) ∈ s
    for (dk, dv) ∈ av
        if ak + dk < Int64.(keys(sixty))[]
            s[ak][dk] = Float64.(values(sixty))[]
        elseif ak + dk < Int64.(keys(seventy))[]
            s[ak][dk] = Float64.(values(seventy))[]
        else
            s[ak][dk] = Float64.(values(eighty))[]
        end
    end
end

j = reduce(merge, [Dict(age => reduce(merge, [Dict(def => 0.0) for def ∈ deferrals])) for age ∈ ages])
for (ak, av) ∈ s
    for (dk, dv) ∈ av
        j[ak][dk] -= 0.005
    end
end

ws = Dict(:Withdrawals => Dict(:Rising => merge(Dict(:Single => s), Dict(:Joint => j))))

location = Dict(:Location => :Withdrawal)
mins = Dict(:Minimums => Dict(:Deferral => 10))
maxes = Dict(:Maximums => Dict(:Age => 84))
inc_type = Dict(:Income_Type => :Multiplier)
params = Dict(:Paramaters => merge(location, mins, maxes, inc_type))
income_rider = Dict(:Rider => merge(ws, params))

val_keys = [:Strategy_Name, :Struct_Type, :Risk_Profile, :Period, :Asset_Class, :Cap, :Floor]
p2p_vals = [:Point_to_Point, :Guard, :Conservative, 1, :SNP_500, 0.06, 0.0]
fix_vals = [:Fixed, :Fixed, :Very_Conservative, 1, :SNP_500, 0.03, 0.03]
p2p = Dict(val_keys .=> p2p_vals)
fix = Dict(val_keys .=> fix_vals)

strategies = Dict(:Strategies => [p2p, fix])

#Fees
surrender = Dict(:Surrender => [0.1, 0.1, 0.1, 0.0875, 0.075, 0.0625, 0.05, 0.0375, 0.025, 0.0125])
fees = Dict(:Fees => merge(Dict(:Contract => 0.0), surrender))

#Benefits
multiplier = Dict(:Multiplier => 1.5)
bonus = Dict(:Bonus => 1.5)
benefit = Dict(:Benefit => Dict(:Options => Dict(:Multiplier => merge(bonus, multiplier))))

alz_222 = Dict(Symbol(222) => merge(benefit, income_rider, strategies, fees))

export alz_222