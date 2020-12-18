function space_from_input(fourth_dimension)
    center = 20
    space = fourth_dimension ?
        zeros(Int8, center * 2, center * 2, center * 2, center * 2) :
        zeros(Int8, center * 2, center * 2, center * 2)

    half = convert(Int, floor(length(readline("input.txt")) / 2))
    y = center - half + 1

    for line in readlines("input.txt")
        for (x, c) in enumerate(split(line, ""))
            if c == "#"
                if fourth_dimension
                    space[y, x + center - half, center, center] = 1
                else
                    space[y, x + center - half, center] = 1
                end
            end
        end

        y += 1
    end

    space
end

function should_be_active(space, pos, dimensions)
    neighbours = filter(!iszero, CartesianIndices(ntuple(_ -> -1:1, dimensions)))

    c = count(==(1), map(
        n -> checkbounds(Bool, space, n + pos) ? space[n + pos] : nothing,
        neighbours
    ))
    (space[pos] == 1 && (c == 2 || c == 3)) || (c == 3)
end

function solve(space, dimensions)
    for _ in 1:6
        new_space = copy(space)

        for index in CartesianIndices(space)
            if should_be_active(space, index, dimensions)
                new_space[index] = 1
            else
                new_space[index] = 0
            end
        end

        space = new_space
    end

    count(==(1), space)
end

# Part 1
println(solve(space_from_input(false), 3))

# Part 2
println(solve(space_from_input(true), 4))
