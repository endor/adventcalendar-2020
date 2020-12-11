function prepare_chart()
    chart = map(l -> split("." * l * ".", ""), readlines("input.txt"))
    width = length(chart[1])
    insert!(chart, 1, fill(".", width))
    push!(chart, fill(".", width))

    chart, width, length(chart)
end

function walk_till_seat(chart, width, height, row, col, x, y)
    while true
        row += x
        col += y

        if row > height || row == 1 || col > width || col == 1
            return "."
        elseif chart[row][col] == "#" || chart[row][col] == "L"
            return chart[row][col]
        end
    end
end

function visible(chart, width, height, row, col)
    [
        walk_till_seat(chart, width, height, row, col, -1, -1),
        walk_till_seat(chart, width, height, row, col, 0, -1),
        walk_till_seat(chart, width, height, row, col, 1, -1),
        walk_till_seat(chart, width, height, row, col, -1, 0),
        walk_till_seat(chart, width, height, row, col, 1, 0),
        walk_till_seat(chart, width, height, row, col, -1, 1),
        walk_till_seat(chart, width, height, row, col, 0, 1),
        walk_till_seat(chart, width, height, row, col, 1, 1)
    ]
end

function no_occupied_visible_seats(chart, width, height, row, col)
    "#" ∉ visible(chart, width, height, row, col)
end

function five_or_more_visible_occupied(chart, width, height, row, col)
    count(==("#"), visible(chart, width, height, row, col)) ≥ 5
end

function surrounding(chart, row, col)
    [
        chart[row-1][col-1], chart[row-1][col], chart[row-1][col+1],
        chart[row][col-1],                      chart[row][col+1],
        chart[row+1][col-1], chart[row+1][col], chart[row+1][col+1]
    ]
end

function no_occupied_adjacent_seats(chart, width, height, row, col)
    "#" ∉ surrounding(chart, row, col)
end

function four_or_more_occupied(chart, width, height, row, col)
    count(==("#"), surrounding(chart, row, col)) ≥ 4
end

function iterate_chart_until_stable(chart, width, height, check_free, check_occupied)
    while true
        new_chart = deepcopy(chart)

        for row in 2:height-1
            for col in 2:width-1
                field = chart[row][col]

                if field == "."
                    new_chart[row][col] = "."
                end

                if field == "L"
                    if check_free(chart, width, height, row, col)
                        new_chart[row][col] = "#"
                    else
                        new_chart[row][col] = "L"
                    end
                end

                if field == "#"
                    if check_occupied(chart, width, height, row, col)
                        new_chart[row][col] = "L"
                    else
                        new_chart[row][col] = "#"
                    end
                end
            end
        end

        if chart == new_chart
            return sum(map(row -> count(==("#"), row), new_chart))
        else
            chart = new_chart
        end
    end
end

function part1(chart, width, height)
    iterate_chart_until_stable(chart, width, height, no_occupied_adjacent_seats,
        four_or_more_occupied)
end

function part2(chart, width, height)
    iterate_chart_until_stable(chart, width, height, no_occupied_visible_seats,
        five_or_more_visible_occupied)
end

chart, width, height = prepare_chart()
println(part1(deepcopy(chart), width, height))
println(part2(chart, width, height))
