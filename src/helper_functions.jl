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


"""
    fill_zeros_bins(real_xs, xs, ys, atol; zero_threshold::Real = 0.0)

Given some digitized binned data, where `xs` are the the bins x axis midpoints and `ys` are
the corresponding values on the y axis, this function fills with zeros the missing bins.

The complete set of bins is given by `real_xs` and `atol` is the absolute tolerance to use
when comparing whether a given element of `xs` is inside of `ys` or not. Smaller values of
`atol` will make less values of `xs` to be found inside `real_xs`.

If a value of `zero_threshold` different than `0` is given, then every bin with a
y value `y < zero_threshold` will be considered as `0.0`.

# Examples
Given the following `real_x` bins and the digitized `x_bins` and `y_bins`:
```
julia> real_bins = [0.5, 1.5, 2.5, 3.5]
4-element Vector{Float64}:
 0.5
 1.5
 2.5
 3.5

julia> x_bins = [0.5001, 2.499987]
2-element Vector{Float64}:
 0.5001
 2.499987

julia> y_bins = [34.7, 4.2]
2-element Vector{Float64}:
 34.7
  4.2
```

We can fill it with zeros by choosing an absolute tolerance of `atol = 1e-4`:
```
julia> fill_zeros_bins(real_bins, x_binx, y_bins, 1e-4)
4-element Vector{Float64}:
 34.7
  0.0
  4.2
  0.0
```

We can also set a zero threshold at `10.0` so every point of `y_bins` smaller than that will
bet zero:
```
julia> fill_zeros_bins(real_bins, x_binx, y_bins, 1e-4; zero_threshold = 10.0)
4-element Vector{Float64}:
 34.7
  0.0
  0.0
  0.0
```

# Notes
A warning is given if the absolute tolerance is very small. This means that the function is
filling with more zeros than needed and some ys values are not taken into account. This
warning has nothing to do whether we set a high `zero_threshold` value or not.
"""
function fill_zeros_bins(real_xs, xs, ys, atol; zero_threshold::Real = 0.0)
    # Array of real binned y axis values
    real_ys = zero(real_xs)

    # Obtain which values of our xs array are in the array of real binned x values
    # and assign their corresponding ys value to the real binned y array
    for i in eachindex(xs)
        indexes = isapprox.(real_xs, xs[i]; atol=atol)
        real_ys[indexes] .= ys[i]
    end

    # Check that the number of zeros added is correct. If it is greater, then the tolerance
    # might be too high
    number_of_zeros = count(x -> x == zero(x), real_ys)
    number_of_zeros_in_ys = count(x -> x == zero(x), ys)
    if ! (number_of_zeros - number_of_zeros_in_ys == length(real_xs) - length(ys))
        warn_message = """Expected to write $(length(real_xs) - length(ys)) zeros, but $number_of_zeros were written.
        Consider increasing the value of `atol` to fix this issue."""
        @warn warn_message
    end

    # Make zero all those elements smaller than the threshold
    zero_index = real_ys .< zero_threshold
    real_ys[zero_index] .= 0.0

    return return hcat(real_xs,real_ys)
end
