#Withdrawals
f = coalesce.(CSV.read(joinpath(pwd(), "inputs", "FIAs", "New York Life", "CIA", "Female.csv"), DataFrame), 0.0)
m = coalesce.(CSV.read(joinpath(pwd(), "inputs", "FIAs", "New York Life", "CIA", "Male.csv"), DataFrame), 0.0)
j = coalesce.(CSV.read(joinpath(pwd(), "inputs", "FIAs", "New York Life", "CIA", "JOint.csv"), DataFrame), 0.0)
deferrals = collect(0:1:12)

function csv2agedict(df::DataFrame, deferrals::Vector{Int64})
    min_age = minimum(df.Age) - 1
    age_dict = []
    for i ∈ axes(df,1)
        def_dict = []
        for d ∈ deferrals
            if df[i,Symbol(d)] > 0 push!(def_dict, Dict(d => df[i,Symbol(d)])) end
        end 
    push!(age_dict, Dict(i + min_age => reduce(merge, def_dict)))
    end
    return reduce(merge, age_dict)
end

fem = Dict(:Female => csv2agedict(f, deferrals))
male = Dict(:Male => csv2agedict(m, deferrals))
joint = Dict(:Joint => csv2agedict(j, deferrals))

ws = Dict(:Withdrawals => Dict(:Level => merge(fem, male, joint)))

#Rider Parameters
income_rider = Dict(:Rider => ws)

#Fees
surrender = Dict(:Surrender => [0.085, 0.08, 0.07, 0.06, 0.05, 0.04, 0.0])
fees = Dict(:Fees => merge(Dict(:Contract => 0.01), surrender))

#Benefits
benefit = Dict(:Benefit => Dict(:Options => Dict(:Fixed => :Fixed)))

cia = Dict(:Clear_Income_Advantage => merge(benefit, income_rider, fees))

export cia