using VectorPlotDigitizer
using Test
using Aqua

@testset "VectorPlotDigitizer.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(VectorPlotDigitizer)
    end
    # Write your tests here.
end
