function part1(target)
    text = read("input.txt", String)
    parent_bags = []
    targets = [target]

    while !isempty(targets)
        t = popat!(targets, 1)

        matches = collect(eachmatch(Regex("^(.*) bags contain.* \\d+ " * t * " bag", "m"), text))

        for m in matches
            push!(parent_bags, m[1])
            push!(targets, m[1])
        end
    end

    length(unique(parent_bags))
end

function part2(target)
    tree = Dict()
    targets = [target]
    count = 0

    for line in eachline("input.txt")
        s = split(line, " bags contain ")
        key = s[1]
        values = split(s[2], ", ")

        if values[1] != "no other bags."
            tree[key] = map(values) do v
                m = match(r"(\d+) (.*) bag", v)
                (parse(Int, m[1]), m[2])
            end
        end
    end

    while !isempty(targets)
        t = popat!(targets, 1)

        count += 1

        if haskey(tree, t)
            for t2 in tree[t]
                i = t2[1]
                while i > 0
                    push!(targets, t2[2])
                    i -= 1
                end
            end
        end
    end

    count - 1
end

println("Bags can contain target bag ", part1("shiny gold"))
println("Target bag contains ", part2("shiny gold"), " bags")
