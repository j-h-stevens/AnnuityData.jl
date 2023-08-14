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
joint = Dict(:JOint => csv2agedict(j, deferrals))

withdrawals = Dict(:Withdrawals => Dict(:Level => merge(fem, male, joint)))

#Rider Parameters
location = Dict(:Location => :Issue)
mins = Dict(:Minimums => Dict(:Deferral => 0))
maxes = Dict(:Maximums => Dict(:Age => 84))
params = Dict(:Paramaters => merge(location, mins, maxes))
income_rider = Dict(:Rider => merge(withdrawals, params))

#Fees
surrender = Dict(:Surrender => [0.085, 0.08, 0.07, 0.06, 0.05, 0.04, 0.0])
fees = Dict(:Fees => merge(Dict(:Contract => 0.01), surrender))

#Company/prodyct
comp_nam = Dict(:Company => :New_York_Life)
comp_rat = Dict(:Comdex => 100)
prod_nam = Dict(:Product_Name => :Clear_Income_Advantage)
prod_type = Dict(:Growth => :Account)

#Product
prod_type = Dict(:Growth_Type => :Account)
cia = Dict(:Clear_Income_Advantage => merge(prod_type, income_rider, fees))

export cia