numbers = [15,12,0,14,3,1]

function part2(numbers)
    dict = Dict()

    for (index, number) in enumerate(numbers)
        dict[number] = index
    end

    current_round = length(numbers) + 1
    last_number = last(numbers)
    previously_spoken = false

    while current_round <= 30000000
        next_number = 0
        last_round = current_round - 1

        if previously_spoken
            next_number = last_round - dict[last_number]
        end

        dict[last_number] = last_round
        last_number = next_number
        previously_spoken = haskey(dict, last_number)
        current_round += 1
    end

    last_number
end

function part1(numbers)
    while length(numbers) !== 2020
        current_number = numbers[1]
        next_number = 0

        if count(==(current_number), numbers) > 1
            next_number = findnext(==(current_number), numbers, 2) - 1
        end

        insert!(numbers, 1, next_number)
    end

    numbers[1]
end

println(part1(reverse(numbers)))
println(part2(numbers))
