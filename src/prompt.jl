abstract type AbstractPrompt end
abstract type AbstractPromptTemplate end

@kwdef struct SystemPromptTemplate <: AbstractPromptTemplate
    template::String
end

@kwdef mutable struct SystemPrompt <: AbstractPrompt
    template::String
    args::Vector{Pair}
end

macro prompt(template::String)
    return SystemPromptTemplate(template=template)
end

function execute(template::AbstractPromptTemplate; kwargs...)
    args = [kwargs...]
    raw_prompt = template.template
    for arg in args
        raw_prompt = replace(raw_prompt, "{{$(arg[1])}}" => arg[2])
    end

    return SystemPrompt(raw_prompt, args)
end

test = @prompt "this is a test prompt that should be compiled {{a}}"

use(test, a=1)