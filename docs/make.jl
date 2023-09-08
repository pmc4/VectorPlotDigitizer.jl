using VectorPlotDigitizer
using Documenter

DocMeta.setdocmeta!(VectorPlotDigitizer, :DocTestSetup, :(using VectorPlotDigitizer); recursive=true)

makedocs(;
    modules=[VectorPlotDigitizer],
    authors="pmc4 <117096890+pmc4@users.noreply.github.com> and contributors",
    repo="https://github.com/pmc4/VectorPlotDigitizer.jl/blob/{commit}{path}#{line}",
    sitename="VectorPlotDigitizer.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://pmc4.github.io/VectorPlotDigitizer.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/pmc4/VectorPlotDigitizer.jl",
    devbranch="main",
)
