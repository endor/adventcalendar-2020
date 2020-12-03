function trees_in_slope(x, y)
    trees = 0
    current_position = 1
    skip = y

    for line in eachline("input.txt")
        if skip == 0
            skip = y
        end

        skip -= 1

        if skip + 1 != y
            continue
        end

        if line[current_position] == '#'
            trees += 1
        end

        current_position += x

        if current_position > length(line)
            current_position = mod(current_position, length(line))
        end
    end

    trees
end

# Part 1
println("Trees: ", trees_in_slope(3, 1))

# Part 2
slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
result = reduce(*, map(s -> trees_in_slope(s[1], s[2]), slopes))

println("Result: ", result)
