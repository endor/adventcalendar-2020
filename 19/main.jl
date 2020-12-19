# Returns key, which represents the number of the rule and
# value, which is an array representing either:
# 1: a letter        - "a"
# 2: an "or" rule    - 2 3 | 3 2
# 3: a "normal" rule - 2 4 5
# 4: loops           - 11: 42 31 | 42 11 31
function parse_rule(line)
    s = split(line, ": ")
    key = parse(Int, s[1])
    value = []

    if contains(s[2], "\"")
        value = [split(s[2], "\"")[2][1], nothing, nothing, nothing]
    elseif contains(s[2], "|")
        sides = split(s[2], " | ")
        a = parse.(Int, split(sides[1], " "))
        b = parse.(Int, split(sides[2], " "))
        value = [nothing, append!(a, b), nothing, nothing]
    else
        value = [nothing, nothing, parse.(Int, split(s[2], " ")), nothing]
    end

    key, value
end

function parse_input()
    rules = Dict()
    messages = []

    reading_rules = true

    for line in eachline("input.txt")
        if isempty(line)
            reading_rules = false
            continue
        end

        if reading_rules
            key, value = parse_rule(line)
            rules[key] = value
        else
            push!(messages, line)
        end
    end

    rules, messages
end

function build_regex(rules, index)
    rule = rules[index]

    if !isnothing(rule[1])
        return rule[1]
    elseif !isnothing(rule[2])
        if length(rule[2]) == 2
            return string(
                "(",
                build_regex(rules, rule[2][1]),
                "|",
                build_regex(rules, rule[2][2]),
                ")"
            )
        else
            return string(
                "(",
                build_regex(rules, rule[2][1]),
                build_regex(rules, rule[2][2]),
                "|",
                build_regex(rules, rule[2][3]),
                build_regex(rules, rule[2][4]),
                ")"
            )
        end
    elseif !isnothing(rule[3])
        return join(map(r -> build_regex(rules, r), rule[3]))
    elseif !isnothing(rule[4])
        if index == 8
            return string("(", build_regex(rules, 42), ")+")
        elseif index == 11
            a = build_regex(rules, 42)
            b = build_regex(rules, 31)

            return string(
                "(",
                string(a, b),
                "|",
                string(a, a, b, b),
                "|",
                string(a, a, a, b, b, b),
                "|",
                string(a, a, a, a, b, b, b, b),
                ")"
            )
        end
    end
end

rules, messages = parse_input()

# Part 1
@show regex = Regex(string("^", build_regex(rules, 0), "\$"))
println(count(m -> !isnothing(match(regex, m)), messages))

# Part 2
rules[8] = [nothing, nothing, nothing, 1]
rules[11] = [nothing, nothing, nothing, 1]
@show regex = Regex(string("^", build_regex(rules, 0), "\$"))
println(count(m -> !isnothing(match(regex, m)), messages))
