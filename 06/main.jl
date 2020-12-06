total_questions_anyone = 0
total_questions_everyone = 0
questions = []
people_in_group = 0

function update_total()
    for question in unique(questions)
        if count(q -> q == question, questions) == people_in_group
            global total_questions_everyone += 1
        end
    end

    global total_questions_anyone += length(unique(questions))
    global questions = []
    global people_in_group = 0
end

for line in eachline("input.txt")
    if isempty(line)
        update_total()
    else
        global people_in_group += 1

        for question in split(line, "")
            push!(questions, question)
        end
    end
end

update_total()

# Part 1
println("Total questions anyone ", total_questions_anyone)

# Part 2
println("Total questions everyone ", total_questions_everyone)
