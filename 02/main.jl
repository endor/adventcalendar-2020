total = 0

for line in eachline("input.txt")
    # 16-17 m: mmmmmmmmmxmmmmwmm
    parts = split(line, " ")

    first_second = split(parts[1], "-")
    first = parse(Int8, first_second[1])
    second = parse(Int8, first_second[2])

    letter = split(parts[2], ":")[1][1]

    first_letter = parts[3][first]
    second_letter = parts[3][second]

    if first_letter != second_letter &&
        (first_letter == letter || second_letter == letter)
        global total = total + 1
    end
end

println("Total: ", total)
