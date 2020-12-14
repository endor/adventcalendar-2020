input = readlines("input.txt")

function part1(input)
    earliest_departure = parse(Int, input[1])
    buses = parse.(Int, filter(x -> x != "x", split(input[2], ",")))

    wait_for_bus = nothing
    earliest_bus = nothing

    for bus in buses
        departure = floor(earliest_departure/bus)*bus+bus - earliest_departure

        if wait_for_bus === nothing || departure < wait_for_bus
            wait_for_bus = departure
            earliest_bus = bus
        end
    end

    wait_for_bus * earliest_bus
end

function part2(input)
    buses = []
    maximum_bus = 0
    minutes_after_maximum_bus = 0

    for (minutes_after, x) in enumerate(split(input[2], ","))
        if x != "x"
            bus = parse(Int, x)

            if bus > maximum_bus
                maximum_bus = bus
                minutes_after_maximum_bus = minutes_after - 1
            end

            push!(buses, (minutes_after - 1, bus))
        end
    end

    base = maximum_bus
    minutes_after = minutes_after_maximum_bus
    timestamp = base

    while true
        d = timestamp - minutes_after

        if any(bus -> (d + bus[1]) % bus[2] != 0, buses)
            timestamp += base
            continue
        end

        return timestamp - minutes_after
    end
end

println(part1(input))
println(part2(input))
