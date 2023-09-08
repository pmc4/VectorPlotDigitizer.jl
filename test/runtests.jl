using VectorPlotDigitizer
using Test
using Aqua

@testset "VectorPlotDigitizer.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(VectorPlotDigitizer; ambiguities = false, unbound_args = false)
    end
    # Write your tests here.
end
