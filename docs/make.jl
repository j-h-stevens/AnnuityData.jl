using AnnuityData
using Documenter

DocMeta.setdocmeta!(AnnuityData, :DocTestSetup, :(using AnnuityData); recursive=true)

makedocs(;
    modules=[AnnuityData],
    authors="John Stevens",
    repo="https://github.com/J-h-stevens/AnnuityData.jl/blob/{commit}{path}#{line}",
    sitename="AnnuityData.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://J-h-stevens.github.io/AnnuityData.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/J-h-stevens/AnnuityData.jl",
    devbranch="main",
)
