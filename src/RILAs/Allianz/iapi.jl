using CSV
using DataFrames

#Withdrawals
ls = CSV.read(joinpath(pwd(), "inputs", "RILAs", "Allianz", "IAPI", "Level_Single.csv"), DataFrame)
lj = CSV.read(joinpath(pwd(), "inputs", "RILAs", "Allianz", "IAPI", "Level_Joint.csv"), DataFrame)
rs = CSV.read(joinpath(pwd(), "inputs", "RILAs", "Allianz", "IAPI", "Rising_Single.csv"), DataFrame)
rj = CSV.read(joinpath(pwd(), "inputs", "RILAs", "Allianz", "IAPI", "Rising_Joint.csv"), DataFrame)

deferrals = parse.(Int64, names(ls)[2:end]) .+ 1
ls_dict = Dict(:Single => reduce(merge, [Dict(j+49 => reduce(merge, [Dict(i-1 => ls[j, i]) for i ∈ deferrals])) for j ∈ axes(ls,1)]))
lj_dict = Dict(:Joint => reduce(merge, [Dict(j+49 => reduce(merge, [Dict(i-1 => lj[j, i]) for i ∈ deferrals])) for j ∈ axes(ls,1)]))
rs_dict = Dict(:Single => reduce(merge, [Dict(j+49 => reduce(merge, [Dict(i-1 => rs[j, i]) for i ∈ deferrals])) for j ∈ axes(ls,1)]))
rj_dict = Dict(:Joint => reduce(merge, [Dict(j+49 => reduce(merge, [Dict(i-1 => rj[j, i]) for i ∈ deferrals])) for j ∈ axes(ls,1)]))

ws = Dict(:Withdrawals => merge(Dict(:Level => merge(ls_dict, lj_dict)), Dict(:Rising => merge(rs_dict, rj_dict))))

#Rider Parameters
location = Dict(:Location => :Issue)
mins = Dict(:Minimums => Dict(:Deferral => 1))
maxes = Dict(:Maximums => Dict(:Age => 84))
params = Dict(:Paramaters => merge(location, mins, maxes))
income_rider = Dict(:Rider => merge(ws, params))

#Crediting Strategies
cs = CSV.read(joinpath(pwd(), "inputs", "RILAs", "Allianz", "IAPI", "Crediting_Strategies.csv"), DataFrame)

val_keys = [:Cap, :Par, :Buffer, :Floor]

#Fees
surrender = Dict(:Surrender => [0.085, 0.08, 0.07, 0.06, 0.05, 0.04, 0.0])
fees = Dict(:Fees => merge(Dict(:Contract => 0.0195), surrender))

#Segment Credit Strategies
function cred_strats(df::DataFrame)
    val_keys = [:Cap, :Par, :Buffer, :Floor]
    op = []
    for strat ∈ [df[df.Strategy_Name .== strat, :] for strat ∈ unique(df.Strategy_Name)]
        per_vals = []
        for period ∈ [strat[strat.Period .== period, :] for period ∈ unique(strat.Period)]
           risk_vals = []
            for risk ∈ [period[period.Risk_Profile .== risk,:] for risk ∈ unique(period.Risk_Profile)]
                ind_vals = []
                for index ∈ [risk[risk.Asset_Class .== index,:] for index ∈ unique(risk.Asset_Class)]
                    vals = []
                    for val ∈ val_keys
                        if typeof(index[:,val][]) == Float64 push!(vals, Dict(val => index[:,val][])) end
                    end
                    push!(ind_vals, Dict(Symbol(index.Asset_Class[1]) => merge(Dict(:Struct_Type => Symbol(index.Struct_Name[1])), reduce(merge, vals))))
                end
                push!(risk_vals, Dict(Symbol(risk.Risk_Profile[1]) => reduce(merge, ind_vals)))
            end
            push!(per_vals, Dict(period.Period[1] => reduce(merge, risk_vals)))
        end
        push!(op, Dict(Symbol(strat.Strategy_Name[1]) => reduce(merge, per_vals)))
    end
    return reduce(merge, op)
end
strategies = Dict(:Strategies => cred_strats(cs))

#Product
prod_type = Dict(:Growth_Type => :Account)
iapi = Dict(:Index_Advantage_Income => merge(prod_type, income_rider, strategies, fees))

export iapi