@views function is_valid(current, preamble)
    for i in preamble
        if current - i ∈ preamble
            return true
        end
    end

    false
end

function find_invalid(preamble_size, input)
    preamble = []

    for i = 1:preamble_size
        push!(preamble, popfirst!(input))
    end

    for i in input
        if is_valid(i, preamble)
            push!(preamble, i)
            popfirst!(preamble)
        else
            return i
        end
    end
end

@views function find_contiguous(invalid, input)
    n = 1

    while true
        for i = n:length(input)
            if sum(input[n:i]) == invalid
                return input[n:i]
            end
        end

        n += 1
    end
end

preamble_size = 25
input = map(l -> parse(Int, l), readlines("input.txt"))

# Part 1
@time invalid = find_invalid(preamble_size, copy(input))
println("The number that doesn't work is ", invalid)

# Part 2
@time numbers = find_contiguous(invalid, input)
println("The encryption weakness is ", sum(extrema(numbers)))
