function part1(jolts)
    diff_1 = 0
    diff_3 = 0
    current = 0

    for j in jolts
        if current + 1 == j
            diff_1 += 1
        elseif current + 3 == j
            diff_3 += 1
        end

        current = j
    end

    diff_1 * diff_3
end

function part2(input)
    diffs = diff(input)
    result = 1
    in_a_row = 0
    perm_map = Dict(0 => 1, 1 => 1, 2 => 2, 3 => 4, 4 => 7)

    for i = 1:length(diffs)
        if diffs[i] == 1
            in_a_row += 1
        else
            result *= perm_map[in_a_row]
            in_a_row = 0
        end
    end

    return result
end

jolts = sort(parse.(Int, readlines("input.txt")))
insert!(jolts, 1, 0)
push!(jolts, maximum(jolts) + 3)

println("Part 1 ", part1(jolts))
println("Part 2 ", part2(jolts))
