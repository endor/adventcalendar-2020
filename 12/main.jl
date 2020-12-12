mutable struct Position
    x
    y
end

@enum Direction::Int64 east=1 south=2 west=3 north=4

function turn_right(direction, value)
    next = Int(direction) + value / 90

    if next > 4
        next = next % 4
    end

    Direction(convert(Int, next))
end

function turn_left(direction, value)
    next = Int(direction) - value / 90

    if next < 1
        next += 4
    end

    Direction(convert(Int, next))
end

function rotate(waypoint, value, multiply)
    for _ in 1:value/90
        x = waypoint.x
        waypoint.x = waypoint.y
        waypoint.y = x
        waypoint.x *= multiply.x
        waypoint.y *= multiply.y
    end

    waypoint
end

function part1()
    current_direction = east
    current_position = Position(0, 0)

    for instruction in readlines("input.txt")
        action = instruction[1]
        value = parse(Int, instruction[2:end])

        if action == 'N' || (current_direction == north && action == 'F')
            current_position.y += value
        elseif action == 'E' || (current_direction == east && action == 'F')
            current_position.x += value
        elseif action == 'S' || (current_direction == south && action == 'F')
            current_position.y -= value
        elseif action == 'W' || (current_direction == west && action == 'F')
            current_position.x -= value
        elseif action == 'R'
            current_direction = turn_right(current_direction, value)
        elseif action == 'L'
            current_direction = turn_left(current_direction, value)
        end
    end

    current_position
end

function part2()
    current_direction = east
    ship = Position(0, 0)
    waypoint = Position(10, 1)

    for instruction in readlines("input.txt")
        action = instruction[1]
        value = parse(Int, instruction[2:end])

        if action == 'F'
            ship.x += value * waypoint.x
            ship.y += value * waypoint.y
        elseif action == 'N'
            waypoint.y += value
        elseif action == 'E'
            waypoint.x += value
        elseif action == 'S'
            waypoint.y -= value
        elseif action == 'W'
            waypoint.x -= value
        elseif action == 'R'
            waypoint = rotate(waypoint, value, Position(1, -1))
        elseif action == 'L'
            waypoint = rotate(waypoint, value, Position(-1, 1))
        end
    end

    ship
end

position = part1()
println(abs(position.x) + abs(position.y))

position = part2()
println(abs(position.x) + abs(position.y))
