function invalid_number(number, min, max)
    n = parse(Int16, number)
    n < min || n > max
end

function invalid(key, value)
    if key == "pid"
        length(value) != 9
    elseif key == "iyr"
        invalid_number(value, 2010, 2020)
    elseif key == "hgt"
        m = match(r"(\d+)(cm|in)", value)

        if m === nothing
            true
        elseif m[2] == "cm"
            invalid_number(m[1], 150, 193)
        else
            invalid_number(m[1], 59, 76)
        end
    elseif key == "hcl"
        match(r"#[0-9a-f]{6}", value) === nothing
    elseif key == "eyr"
        invalid_number(value, 2020, 2030)
    elseif key == "ecl"
        !(value in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
    elseif key == "byr"
        invalid_number(value, 1920, 2002)
    else
        false
    end
end

function validate(line)
    valid = true

    for key in ["pid", "iyr", "hgt", "hcl", "eyr", "ecl", "byr"]
        if !haskey(current_passport, key) || invalid(key, current_passport[key])
            valid = false
        end
    end

    if valid
        global valid_passports += 1
    end

    global current_passport = Dict()
end

valid_passports = 0
current_passport = Dict()

for line in eachline("input.txt")
    if isempty(line)
        validate(line)
    else
        for field in split(line, " ")
            f = split(field, ":")
            global current_passport[f[1]] = f[2]
        end
    end
end

# For some reason `eachline` does not include the last empty line
validate("")

println("Valid passports: ", valid_passports)
