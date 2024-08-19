abstract type AbstractPrompt end

@kwdef struct SystemPromptTemplate <: AbstractPrompt
    template::String
end

macro prompt(template::String)
    return SystemPromptTemplate(template=template)
end

function execute(template::AbstractPrompt; kwargs...)
    args = [kwargs...]
    raw_prompt = template.template
    for arg in args
        raw_prompt = replace(raw_prompt, "{{$(arg[1])}}" => arg[2])
    end

    return SystemPrompt(raw_prompt, args)
end