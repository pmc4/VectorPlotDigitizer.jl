function rel2abs_coordinates(data)
    # Permutate the matrix for faster processing
    data_perm = permutedims(data)
    # Transform the data
    ix = axes(data_perm,2)
    for i in ix[(begin+1):end]
        data_perm[:,i] += data_perm[:,i-1]
    end
    # Transpose again
    return permutedims(data_perm)
end

function axis_units(x0_path, x1_path, x0_real, x1_real)
    # Compute the distance between the path points
    Δx_path = x1_path - x0_path
    Δx_real = x1_real - x0_real
    # Compute how many real units are one path unit
    units = Δx_real / Δx_path

    return units
end

function calibrate_axis(l_path, l_real; is_xaxis_log = false, is_yaxis_log = false, is_yinverted = false)
    # Read the L path coordinates by creating a temporary file
    outfile = "l_coords.txt"
    extract_svgpath(l_path, outfile)
    # Read file contents as a Matrix
    l_path = readdlm(outfile, ',', Float64, '\n')
    # Delete file
    rm(outfile)
    # Convert to absolute coordinates
    l_path = rel2abs_coordinates(l_path)

    # Compute points of the transformation
    xp0 = l_path[2,1]
    xp1 = l_path[3,1]
    yp0 = l_path[2,2]
    yp1 = l_path[1,2]
    # If axis is log, transform the real coordinates to the exp10 exponents
    if is_xaxis_log
        xr0 = log10(l_real[2,1])
        xr1 = log10(l_real[3,1])
    else
        xr0 = l_real[2,1]
        xr1 = l_real[3,1]
    end
    if is_yaxis_log
        yr0 = log10(l_real[2,2])
        yr1 = log10(l_real[1,2])
    else
        yr0 = l_real[2,2]
        yr1 = l_real[1,2]
    end

    # Compute x and y axis units
    x_axis_units = axis_units(xp0, xp1, xr0, xr1)
    y_axis_units = axis_units(yp0, yp1, yr0, yr1)
    # Create options dictionary to be read by the transforming function
    options = Dict("xunits" => x_axis_units, "yunits" => y_axis_units,
    "xp0" => xp0, "xr0" => xr0, "yp0" => yp0, "yr0" => yr0,
    "isxlog" => is_xaxis_log, "isylog" => is_yaxis_log, "isyinverted" => is_yinverted
    )
    return options
end


function extract_svgpath(input_str::AbstractString, outfile::String)
    # Split string in each space
    str_splitted = split(input_str, ' ')

    open(outfile, "w") do f
        case = "m" # Command m, l, h or v of the SVG path
        for s in str_splitted # Loop everything and decide
            if occursin(s, "mlhv")
                case = s
            else
                if case == "m" || case == "l"
                    line = s
                elseif case == "h"
                    line = s * ",0.0"
                elseif case == "v"
                    line = "0.0," * s
                end

                write(f, line * "\n")
            end
        end
    end
end

function extract_svgpath(input_str::AbstractString, outfile::String, options::Dict)
    # Transform svg path to txt first
    tempfile = outfile * "_tmp"
    extract_svgpath(input_str, tempfile)
    # Read data
    data = readdlm(tempfile, ',', Float64, '\n')
    # Delete file
    rm(tempfile)
    # Obtain units and points from options dictionary
    xunits = opts["xunits"]
    yunits = opts["yunits"]
    xr0 = opts["xr0"]
    xp0 = opts["xp0"]
    yr0 = opts["yr0"]
    yp0 = opts["yp0"]
    # Convert data to absolute coordinates
    data = rel2abs_coordinates(data)
    # Change path units to real units
    data[:,1] .= (data[:,1] .- xp0) .* xunits .+ xr0
    data[:,2] .= (data[:,2] .- yp0) .* yunits .+ yr0
    # If axis scale is log, we have obtained the exponents of the base 10. Exponentiate
    if opts["isxlog"]
        data = exp10.(data[:,1])
    end
    if opts["isylog"]
        data[:,2] .= exp10.(data[:,2])
    end
    # ! The minus sign is automatically incorporated as long as the data and the L coordinates of the axis
    # ! follow the same criteria of svg path. DON'T MIX THEM!

    # Save file
    open(outfile, "w") do f
        writedlm(f, data, ',')
    end
end
