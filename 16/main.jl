@enum ParseState Rules MyTicket NearbyTickets

struct Rule
    name::String
    min1::Int
    max1::Int
    min2::Int
    max2::Int
end

function parse_input()
    parse_state = Rules
    rules = []
    my_ticket = nothing
    nearby_tickets = []

    for line in readlines("input.txt")
        if isempty(line)
            continue
        elseif contains(line, "your ticket")
            parse_state = MyTicket
            continue
        elseif contains(line, "nearby tickets")
            parse_state = NearbyTickets
            continue
        end

        if parse_state == Rules
            m = match(r"([^:]+): (\d+)-(\d+) or (\d+)-(\d+)", line)

            push!(rules, Rule(
                m[1],
                parse(Int, m[2]),
                parse(Int, m[3]),
                parse(Int, m[4]),
                parse(Int, m[5])
            ))
        elseif parse_state == MyTicket
            my_ticket = parse.(Int, split(line, ","))
        elseif parse_state == NearbyTickets
            push!(nearby_tickets, parse.(Int, split(line, ",")))
        end
    end

    (rules, my_ticket, nearby_tickets)
end

function matches_rule(rule, value)
    (rule.min1 ≤ value ≤ rule.max1) ||
        (rule.min2 ≤ value ≤ rule.max2)
end

function part1(rules, nearby_tickets)
    invalid = 0

    for ticket in nearby_tickets
        for f in ticket
            if !any(r -> matches_rule(r, f), rules)
                invalid += f
            end
        end
    end

    invalid
end

function part2(rules, nearby_tickets, my_ticket)
    filter!(
        t -> all(f -> any(r -> matches_rule(r, f), rules), t),
        nearby_tickets,
    )

    possible_rule_positions = Dict()

    for field_number in 1:length(my_ticket)
        for rule in rules
            if all(t -> matches_rule(rule, t[field_number]), nearby_tickets)
                if haskey(possible_rule_positions, rule.name)
                    push!(possible_rule_positions[rule.name], field_number)
                else
                    possible_rule_positions[rule.name] = [field_number]
                end
            end
        end
    end

    next = findall(x -> length(x) == 1, possible_rule_positions)
    unique_rule_positions = Dict()

    while length(unique_rule_positions) ≠ length(rules)
        rule = popfirst!(next)
        position = first(possible_rule_positions[rule])
        unique_rule_positions[rule] = position
        delete!(possible_rule_positions, rule)
        for (key, value) in possible_rule_positions
            filter!(p -> p ≠ position, value)
            if length(value) == 1
                push!(next, key)
            end
        end
    end

    filter!(r -> startswith(r.first, "departure"), unique_rule_positions)
    prod(map(pos -> my_ticket[pos], values(unique_rule_positions)))
end

rules, my_ticket, nearby_tickets = parse_input()
println(part1(rules, nearby_tickets))
println(part2(rules, nearby_tickets, my_ticket))
