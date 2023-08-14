#Withdrawals
r = 0.06
ages = collect(50:1:80)
deferrals = collect(1:1:12)
sws = Dict(ages .=> zeros(length(ages)))
for i ∈ collect(50:1:59) sws[i] = 0.0325 end 
for i ∈ collect(60:1:64) sws[i] = 0.0375 end 
for i ∈ collect(65:1:69) sws[i] = 0.0475 end 
for i ∈ collect(70:1:74) sws[i] = 0.0525 end 
for i ∈ collect(75:1:80) sws[i] = 0.0575 end
def_ws = Dict(deferrals .=> zeros(length(deferrals)))

f = reduce(merge, [Dict(i => Dict(deferrals .=> zeros(length(deferrals)))) for i ∈ ages])
for (ak, av) ∈ sws
    for dk ∈ keys(def_ws)
        if ak + dk < 81
            if dk < 12
                f[ak][dk] = av * (1.0 + min(dk,10) * r)
            elseif dk == 12
                f[ak][dk] = av * 2
            end
        elseif ak + dk > 79
            f[ak][dk] = av * (1.0 + (80 - ak) * r)
        end
    end
end
m = f
j = reduce(merge, [Dict(ak => reduce(merge, [Dict(dk => dv - 0.005) for (dk,dv) ∈ av])) for (ak,av) ∈ f])

fem = Dict(:Female => f)
male = Dict(:Male => m)
joint = Dict(:Joint => j)

withdrawals = Dict(:Withdrawals => Dict(:Level => merge(fem, male, joint)))

#Rider Parameters
income_rider = Dict(:Rider => withdrawals)

#Fees
surrender = Dict(:Surrender => [0.085, 0.08, 0.07, 0.06, 0.05, 0.04, 0.0])
fees = Dict(:Fees => merge(Dict(:Contract => 0.0125), Dict(:Rider => 0.013), surrender))

#Company/prodyct
prod_type = Dict(:Growth => :Simple)

ric = Dict(:Retirement_Income_Choice => merge(prod_type, income_rider, fees))

export ric