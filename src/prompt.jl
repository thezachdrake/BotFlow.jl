"""
    AbstractPromptTempalte

Base prompt type for interacting with LLMs.
"""
abstract type AbstractPromptTemplate end

"""
    SystemPromptTemplate
"""
struct SystemPromptTemplate <: AbstractPromptTemplate
    template::String
end

macro prompt(template::String)
    return SystemPromptTemplate(template)
end

function execute(
    template::AbstractPromptTemplate,
    ctx::SequentialContext,
)::SequentialContext
    raw_prompt = template.template
    for data in ctx.data
        raw_prompt = replace(raw_prompt, "{{$(data[1])}}" => data[2])
    end
    ctx.prompt = raw_prompt

    return ctx
end