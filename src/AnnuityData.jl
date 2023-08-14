module AnnuityData

using CSV
using DataFrames
using JSON3

include(joinpath(pwd(), "src", "RILAs","Allianz", "iapi.jl"))

#Merge Allianz RILAs
alz = Dict(:Allianz => merge(Dict(:Comdex => 97), Dict(:Products => iapi)))
rilas = Dict(:RILAs => alz)

open(joinpath(pwd(), "Outputs/RILAs.json"), "w") do io
    JSON3.write(io, rilas)
end

include(joinpath(pwd(), "src", "FIAs","New_York_Life", "cia.jl"))
#Merge Allianz RILAs
nyl = Dict(:New_York_Life => merge(Dict(:Comdex => 100), Dict(:Products => cia)))

fias = Dict(:FIAs => nyl)
open(joinpath(pwd(), "Outputs/FIAs.json"), "w") do io
    JSON3.write(io, fias)
end

include(joinpath(pwd(), "src", "VAs","Thrivent", "ric.jl"))
#Merge Allianz RILAs
tf = Dict(:Thrivent_Financial => merge(Dict(:Comdex => 100), Dict(:Products => ric)))

vas = Dict(:VAs => tf)
open(joinpath(pwd(), "Outputs/VAs.json"), "w") do io
    JSON3.write(io, vas)
end

end
