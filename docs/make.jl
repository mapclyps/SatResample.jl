using SatResample
using Documenter

makedocs(;
    modules=[SatResample],
    authors="Marcus Huntemann <marcus.huntemann@gmail.com> and contributors",
    repo="https://github.com/mapclyps/SatResample.jl/blob/{commit}{path}#L{line}",
    sitename="SatResample.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mapclyps.github.io/SatResample.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mapclyps/SatResample.jl",
)
