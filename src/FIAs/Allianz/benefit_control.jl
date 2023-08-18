#Withdrawals
deferrals = collect(2:1:12)

ages = collect(50:1:80)
swdr = Dict(ages .=> zeros(length(ages)))
[swdr[i] = 0.03 for i in collect(50:1:54)]
[swdr[i] = 0.035 for i in collect(55:1:59)]
[swdr[i] = 0.04 for i in collect(60:1:69)]
[swdr[i] = 0.045 for i in collect(70:1:79)]
[swdr[i] = 0.05 for i in collect(80:1:100)]

s = reduce(merge, [Dict(age => reduce(merge, [Dict(def => 0.0) for def ∈ deferrals])) for age ∈ ages])

for (ak, av) ∈ s
    for (dk, dv) ∈ av
        s[ak][dk] = swdr[ak+dk]
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
mins = Dict(:Minimums => Dict(:Deferral => 2))
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
surrender = Dict(:Surrender => [0.093, 0.093, 0.083, 0.073, 0.0625, 0.0525, 0.042, 0.0315, 0.021, 0.0105])
fees = Dict(:Fees => merge(Dict(:Contract => 0.0), surrender))

#Benefits
op1 = Dict(:Accelerated => merge(Dict(:Multiplier => 2.5), Dict(:Discount => 0.5)))
op2 = Dict(:Balanced => merge(Dict(:Multiplier => 1.5), Dict(:Discount => 0.0)))
bonus = Dict(:Bonus => 1.25)
benefit = Dict(:Benefit => merge(bonus, Dict(:Options => merge(op1, op2))))

#Product
prod_type = Dict(:Growth_Type => :Multiplier)
alz_bc = Dict(:Benefit_Control => merge(prod_type, benefit, income_rider, strategies, fees))

export alz_bc