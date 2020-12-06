rows = collect(0:127)
columns = collect(0:7)

@views function find(items, instructions)
    if length(items) == 1
        items[1]
    else
        i = instructions[1]
        half = floor(Int, length(items)/2)

        find(i == 0 ? items[1:half] : items[half + 1:end],
            instructions[2:end])
    end
end

function str_to_int(str)
    (str == "F" || str == "L") ? 0 : 1
end

@views function seat_id_from_line(line)
    characters = map(str_to_int, split(line, ""))
    row = find(rows[:], characters[1:7])
    column = find(columns[:], characters[8:10])
    row * 8 + column
end

seat_ids = map(seat_id_from_line, eachline("input.txt"))
max_seat_id = maximum(seat_ids)

# Part 1
println("Maximum seat id ", max_seat_id)

# Part 2
for seat_id in minimum(seat_ids):max_seat_id
    if seat_id - 1 ∈ seat_ids && seat_id + 1 ∈ seat_ids && seat_id ∉ seat_ids
        println("My seat ", seat_id)
        break
    end
end
