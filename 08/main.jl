function calculate(lines)
    position = 1
    seen = []
    acc = 0

    while true
        if position ∈ seen
            return (true, acc)
        elseif position == length(lines) + 1
            return (false, acc)
        else
            push!(seen, position)
            line = lines[position]

            if startswith(line, "nop")
                position += 1
            elseif startswith(line, "acc")
                val = parse(Int, line[5:end])
                acc += val
                position += 1
            elseif startswith(line, "jmp")
                val = parse(Int, line[5:end])
                position += val
            end
        end
    end
end

function part1(lines)
    (_, acc) = calculate(lines)
    acc
end

function part2(lines)
    for (i, line) in enumerate(lines)
        if startswith(line, "nop")
            lines[i] = replace(line, "nop" => "jmp")
            (inf, acc) = calculate(lines)
            if !inf
                return acc
            end
            lines[i] = replace(line, "jmp" => "nop")
        elseif startswith(line, "jmp")
            lines[i] = replace(line, "jmp" => "nop")
            (inf, acc) = calculate(lines)
            if !inf
                return acc
            end
            lines[i] = replace(line, "nop" => "jmp")
        end
    end
end

lines = readlines("input.txt")

println("Accumulator after first infitite loop ", part1(lines))
println("Accumulator after successful fix ", part2(lines))
