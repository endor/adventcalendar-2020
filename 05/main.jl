rows = collect(0:127)
columns = collect(0:7)

function find(items, instructions)
    if length(items) == 1
        items[1]
    else
        i = instructions[1]
        l = length(items)
        half_l = floor(Int, l/2)

        find(i == 0 ? view(items, 1:half_l) : view(items, (half_l + 1):l),
            view(instructions, 2:length(instructions)))
    end
end

function str_to_int(str)
    (str == "F" || str == "L") ? 0 : 1
end

function seat_id_from_line(line)
    characters = map(str_to_int, split(line, ""))
    row = find(view(rows, :), view(characters, 1:7))
    column = find(view(columns, :), view(characters, 8:10))
    row * 8 + column
end

# Part 1
println("Maximum seat id ", maximum(map(seat_id_from_line, eachline("input.txt"))))

# Part 2
S = map(seat_id_from_line, eachline("input.txt"))
M = last(rows) * 8 + last(columns)

for I in 0:M
    if I - 1 ∈ S && I + 1 ∈ S && I ∉ S
        println("My seat ", I)
    end
end
