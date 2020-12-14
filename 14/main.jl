using Combinatorics

function locations_from_bitmask(bitmask)
    xs = count(c -> c == "X", bitmask)
    cs = [combinations(1:xs)...]
    push!(cs, [])

    map(cs) do c
        location = copy(bitmask)
        n = 0

        for (index, character) in enumerate(location)
            if character == "X"
                n += 1
                location[index] = n ∈ c ? "1" : "0"
            end
        end

        parse(Int, join(location), base = 2)
    end
end

function part2(instructions)
    memory = Dict()
    bitmask = repeat("X", 36)

    for instruction in instructions
        if instruction[1] === nothing
            bitmask = instruction[2]
        else
            bits = split(string(instruction[1], base = 2, pad = 36), "")

            for (index, bit) in enumerate(bitmask)
                if bit == '1' || bit == 'X'
                    bits[index] = string(bit)
                end
            end

            for location in locations_from_bitmask(bits)
                memory[location] = instruction[2]
            end
        end
    end

    sum(values(memory))
end

function part1(instructions)
    memory = Dict()
    bitmask = repeat("X", 36)

    for instruction in instructions
        if instruction[1] === nothing
            bitmask = instruction[2]
        else
            bits = split(string(instruction[2], base = 2, pad = 36), "")

            for (index, bit) in enumerate(bitmask)
                if bit != 'X'
                    bits[index] = string(bit)
                end
            end

            memory[instruction[1]] = parse(Int, join(bits), base = 2)
        end
    end

    sum(values(memory))
end

lines = readlines("input.txt")
instructions = map(lines) do line
    if contains(line, "mask")
        (nothing, split(line, " = ")[2])
    else
        m = match(r"mem\[(\d+)\] = (\d+)", line)
        (parse(Int, m[1]), parse(Int, m[2]))
    end
end

println(part1(instructions))
println(part2(instructions))
