@views function is_valid(current, preamble)
    if length(preamble) == 1
        false
    else
        n = preamble[1]

        for i in preamble[2:end]
            if n + i == current
                return true
            end
        end

        is_valid(current, preamble[2:end])
    end
end

function find_invalid(preamble_size, input)
    preamble = []

    for i = 1:preamble_size
        push!(preamble, popat!(input, 1))
    end

    for i in input
        if is_valid(i, preamble)
            push!(preamble, i)
            popat!(preamble, 1)
        else
            return i
        end
    end
end

@views function find_contiguous(invalid, input)
    for i = 1:length(input)
        if sum(input[1:i]) == invalid
            return input[1:i]
        end
    end

    find_contiguous(invalid, input[2:end])
end

preamble_size = 25
input = map(l -> parse(Int, l), readlines("input.txt"))

# Part 1
invalid = find_invalid(preamble_size, copy(input))
println("The number that doesn't work is ", invalid)

# Part 2
numbers = find_contiguous(invalid, input)
println("The encryption weakness is ", minimum(numbers) + maximum(numbers))
