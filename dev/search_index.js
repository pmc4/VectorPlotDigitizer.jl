var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = VectorPlotDigitizer","category":"page"},{"location":"#VectorPlotDigitizer","page":"Home","title":"VectorPlotDigitizer","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for VectorPlotDigitizer.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [VectorPlotDigitizer]","category":"page"},{"location":"#VectorPlotDigitizer.binedges_to_bin_midpoints-Tuple{Any}","page":"Home","title":"VectorPlotDigitizer.binedges_to_bin_midpoints","text":"binedges_to_bin_midpoints(data; zero_threshold::Real = 0.0, atol::Real= 0.0)\n\nTransforms a set of points that delimits the vertexes of a binned plot into a set of points for each bin mid point value.\n\ndata must be two-column array of numbers that delimit some bin vertexes. The function will detect a bin when two consecutive values of the y axis are not vertical. In such case it will compute the midpoint value of the x axis and take that y axis value.\n\nIf a value of zero_threshold different than 0 is given, then every detected bin with a y value y < zero_threshold will be considered as 0.0.\n\nIf a value of atol is provided, this will be taken as the absolute tolerance in the isapprox method that checks if two points are a straigth vertical line or not. Higher values of atol may give undesired results.\n\n\n\n\n\n","category":"method"},{"location":"#VectorPlotDigitizer.fill_zeros_bins-NTuple{4, Any}","page":"Home","title":"VectorPlotDigitizer.fill_zeros_bins","text":"fill_zeros_bins(real_xs, xs, ys, atol; zero_threshold::Real = 0.0)\n\nGiven some digitized binned data, where xs are the the bins x axis midpoints and ys are the corresponding values on the y axis, this function fills with zeros the missing bins.\n\nThe complete set of bins is given by real_xs and atol is the absolute tolerance to use when comparing whether a given element of xs is inside of ys or not. Smaller values of atol will make less values of xs to be found inside real_xs.\n\nIf a value of zero_threshold different than 0 is given, then every bin with a y value y < zero_threshold will be considered as 0.0.\n\nExamples\n\nGiven the following real_x bins and the digitized x_bins and y_bins:\n\njulia> real_bins = [0.5, 1.5, 2.5, 3.5]\n4-element Vector{Float64}:\n 0.5\n 1.5\n 2.5\n 3.5\n\njulia> x_bins = [0.5001, 2.499987]\n2-element Vector{Float64}:\n 0.5001\n 2.499987\n\njulia> y_bins = [34.7, 4.2]\n2-element Vector{Float64}:\n 34.7\n  4.2\n\nWe can fill it with zeros by choosing an absolute tolerance of atol = 1e-4:\n\njulia> fill_zeros_bins(real_bins, x_binx, y_bins, 1e-4)\n4-element Vector{Float64}:\n 34.7\n  0.0\n  4.2\n  0.0\n\nWe can also set a zero threshold at 10.0 so every point of y_bins smaller than that will bet zero:\n\njulia> fill_zeros_bins(real_bins, x_binx, y_bins, 1e-4; zero_threshold = 10.0)\n4-element Vector{Float64}:\n 34.7\n  0.0\n  0.0\n  0.0\n\nNotes\n\nA warning is given if the absolute tolerance is very small. This means that the function is filling with more zeros than needed and some ys values are not taken into account. This warning has nothing to do whether we set a high zero_threshold value or not.\n\n\n\n\n\n","category":"method"}]
}