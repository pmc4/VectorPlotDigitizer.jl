module VectorPlotDigitizer

using DelimitedFiles

export calibrate_axis, extract_svgpath

export binedges_to_bin_midpoints, fill_zeros_bins

include("core_functions.jl")
include("helper_functions.jl")

end # module
