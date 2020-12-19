is_number(n) = '0' ≤ n ≤ '9'

function part1(formula, pos)
    result = nothing
    op = nothing

    while pos <= length(formula)
        next = formula[pos]

        if next == '(' || is_number(next)
            n, pos = next == '(' ?
                part1(formula, pos + 1) :
                (parse(Int, next), pos)

            if isnothing(op)
                result = n
            else
                op == '*' ? result *= n : result += n
            end

            op = nothing
        elseif next == ')'
            return result, pos
        elseif next == '*' || next == '+'
            op = next
        end

        pos += 1
    end

    result, pos
end

function calculate_brackets(formula)
    while contains(formula, '(')
        m = match(r"\(([^()]+)\)", formula)
        formula = replace(formula, string('(', m[1], ')') => string(part2(m[1])), count = 1)
    end

    formula
end

function calculate_sums(formula)
    while contains(formula, '+')
        m = match(r"(\d+) \+ (\d+)", formula)
        a = parse(Int, m[1])
        b = parse(Int, m[2])

        formula = replace(formula, string(a, " + ", b) => string(a + b), count = 1)
    end

    formula
end

function calculate_prod(formula)
    while contains(formula, '*')
        m = match(r"(\d+) \* (\d+)", formula)
        a = parse(Int, m[1])
        b = parse(Int, m[2])
        formula = replace(formula, string(a, " * ", b) => string(a * b), count = 1)
    end

    formula
end

function part2(formula)
    x = string(formula)
    formula = calculate_brackets(formula)
    formula = calculate_sums(formula)
    formula = calculate_prod(formula)
    parse(Int, formula)
end

@show sum(map(formula -> part1(formula, 1)[1], eachline("input.txt")))
@show sum(map(formula -> part2(formula)[1], eachline("input.txt")))
