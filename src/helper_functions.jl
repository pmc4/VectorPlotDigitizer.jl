"""
    binedges_to_bin_midpoints(data; zero_threshold::Real = 0.0, atol::Real= 0.0)

Transforms a set of points that delimits the vertexes of a binned plot into a set of points
for each bin mid point value.

`data` must be two-column array of numbers that delimit some bin vertexes. The function will
detect a bin when two consecutive values of the y axis are not vertical. In such case it will
compute the midpoint value of the x axis and take that y axis value.

If a value of `zero_threshold` different than `0` is given, then every detected bin with a
y value `y < zero_threshold` will be considered as `0.0`.

If a value of `atol` is provided, this will be taken as the absolute tolerance in the
`isapprox` method that checks if two points are a straigth vertical line or not. Higher
values of `atol` may give undesired results.
"""
function binedges_to_bin_midpoints(data; zero_threshold::Real = 0.0, atol::Real= 0.0)
    # Extract x and y values
    xs = data[:,1]
    ys = data[:,2]

    # Store selected points in these arrays
    x = Float64[]
    y = Float64[]

    for i in eachindex(ys[begin:end-1])
        # If we are on a vertical line, ignore it
        # Use isapprox to allow for some margin
        if !(isapprox(ys[i+1] - ys[i], 0.0; atol = atol))
            continue
        else
            midpoint = (xs[i+1] + xs[i]) / 2

            append!(x, midpoint)

            if ys[i] <= zero_threshold
                append!(y, 0.0)
            else
                append!(y, ys[i])
            end
        end
    end

    return hcat(x,y)
end
