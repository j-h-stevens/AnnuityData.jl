module AnnuityData

using CSV
using DataFrames
using JSON3

include(joinpath(pwd(), "src", "RILAs","Allianz", "Allianz.jl"))

#RILAs
rilas = Dict(:RILAs => alz_rilas)

open(joinpath(pwd(), "Outputs/RILAs.json"), "w") do io
    JSON3.write(io, rilas)
end

#FIAs
include.(joinpath(pwd(), "src", "FIAs","Allianz", "Allianz.jl"))
include(joinpath(pwd(), "src", "FIAs","New_York_Life", "nyl.jl"))

#Merge
fias = Dict(:FIAs => merge(alz_fias, nyl_fias))
#Save
open(joinpath(pwd(), "Outputs/FIAs.json"), "w") do io
    JSON3.write(io, fias)
end

include(joinpath(pwd(), "src", "VAs","Thrivent", "Thrivent.jl"))
#Merge VAs

vas = Dict(:VAs => tf_vas)
open(joinpath(pwd(), "Outputs/VAs.json"), "w") do io
    JSON3.write(io, vas)
end

end
