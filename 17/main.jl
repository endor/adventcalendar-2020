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

    center, space
end

function three_dimensional_neighbours()
    map(index -> CartesianIndex(index...), [
        [ 0,  0,  1], [ 0,  0, -1], [ 1,  0,  1], [ 1,  0,  0],
        [ 1,  0, -1], [-1,  0, -1], [-1,  0,  0], [-1,  0,  1],
        [ 0,  1,  1], [ 0,  1,  0], [ 0,  1, -1], [ 1,  1,  1],
        [ 1,  1,  0], [ 1,  1, -1], [-1,  1, -1], [-1,  1,  0],
        [-1,  1,  1], [ 0, -1,  1], [ 0, -1,  0], [ 0, -1, -1],
        [ 1, -1,  1], [ 1, -1,  0], [ 1, -1, -1], [-1, -1, -1],
        [-1, -1,  0], [-1, -1,  1],
    ])
end

function four_dimensional_neighbours()
    map(index -> CartesianIndex(index...), [
        [ 0,  0,  0, -1], [ 0,  0,  1, -1], [ 0,  0, -1, -1],
        [ 1,  0,  1, -1], [ 1,  0,  0, -1], [ 1,  0, -1, -1],
        [-1,  0, -1, -1], [-1,  0,  0, -1], [-1,  0,  1, -1],
        [ 0,  1,  1, -1], [ 0,  1,  0, -1], [ 0,  1, -1, -1],
        [ 1,  1,  1, -1], [ 1,  1,  0, -1], [ 1,  1, -1, -1],
        [-1,  1, -1, -1], [-1,  1,  0, -1], [-1,  1,  1, -1],
        [ 0, -1,  1, -1], [ 0, -1,  0, -1], [ 0, -1, -1, -1],
        [ 1, -1,  1, -1], [ 1, -1,  0, -1], [ 1, -1, -1, -1],
        [-1, -1, -1, -1], [-1, -1,  0, -1], [-1, -1,  1, -1],

        [ 0,  0,  1,  0], [ 0,  0, -1,  0], [ 1,  0,  1,  0],
        [ 1,  0,  0,  0], [ 1,  0, -1,  0], [-1,  0, -1,  0],
        [-1,  0,  0,  0], [-1,  0,  1,  0], [ 0,  1,  1,  0],
        [ 0,  1,  0,  0], [ 0,  1, -1,  0], [ 1,  1,  1,  0],
        [ 1,  1,  0,  0], [ 1,  1, -1,  0], [-1,  1, -1,  0],
        [-1,  1,  0,  0], [-1,  1,  1,  0], [ 0, -1,  1,  0],
        [ 0, -1,  0,  0], [ 0, -1, -1,  0], [ 1, -1,  1,  0],
        [ 1, -1,  0,  0], [ 1, -1, -1,  0], [-1, -1, -1,  0],
        [-1, -1,  0,  0], [-1, -1,  1,  0],

        [ 0,  0,  0,  1], [ 0,  0,  1,  1], [ 0,  0, -1,  1],
        [ 1,  0,  1,  1], [ 1,  0,  0,  1], [ 1,  0, -1,  1],
        [-1,  0, -1,  1], [-1,  0,  0,  1], [-1,  0,  1,  1],
        [ 0,  1,  1,  1], [ 0,  1,  0,  1], [ 0,  1, -1,  1],
        [ 1,  1,  1,  1], [ 1,  1,  0,  1], [ 1,  1, -1,  1],
        [-1,  1, -1,  1], [-1,  1,  0,  1], [-1,  1,  1,  1],
        [ 0, -1,  1,  1], [ 0, -1,  0,  1], [ 0, -1, -1,  1],
        [ 1, -1,  1,  1], [ 1, -1,  0,  1], [ 1, -1, -1,  1],
        [-1, -1, -1,  1], [-1, -1,  0,  1], [-1, -1,  1,  1],
    ])
end

function should_be_active(space, y, x, z, a)
    position = isnothing(a) ?
        CartesianIndex(y, x, z) :
        CartesianIndex(y, x, z, a)

    neighbours = isnothing(a) ?
        three_dimensional_neighbours() :
        four_dimensional_neighbours()

    c = count(==(1), map(n -> space[n + position], neighbours))
    (space[position] == 1 && (c == 2 || c == 3)) || (c == 3)
end

function part1(center, space)
    size = center * 2


    for _ in 1:6
        new_space = copy(space)

        for z in 2:(size - 1)
            for y in 2:(size - 1)
                for x in 2:(size - 1)
                    if should_be_active(space, y, x, z, nothing)
                        new_space[y, x, z] = 1
                    else
                        new_space[y, x, z] = 0
                    end
                end
            end
        end

        space = new_space
    end

    count(==(1), space)
end

function part2(center, space)
    size = center * 2

    for _ in 1:6
        new_space = copy(space)

        for a in 2:(size - 1)
            for z in 2:(size - 1)
                for y in 2:(size - 1)
                    for x in 2:(size - 1)
                        if should_be_active(space, y, x, z, a)
                            new_space[y, x, z, a] = 1
                        else
                            new_space[y, x, z, a] = 0
                        end
                    end
                end
            end
        end

        space = new_space
    end

    count(==(1), space)
end

println(part1(space_from_input(false)...))
println(part2(space_from_input(true)...))
