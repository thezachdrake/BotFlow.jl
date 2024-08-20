abstract type AbstractFlow end

"""
    SequentialFlow

A DAG which executes prompts, models, and processes in sequence.
"""
mutable struct SequentialFlow <: AbstractFlow
    steps::Vector{Union{AbstractPrompt, AbstractLangModel, AbstractProcess}}
end

"""
    step₁ → step₂ → ⋯ → stepₙ

Create a [`SequentialFlow`](@ref) flow with
`[step₁, step₂, …, stepₙ]`.
"""
→(prompt::AbstractPrompt, model::AbstractLangModel) = SequentialFlow([prompt, model])
→(prompt::AbstractPrompt, flow::SequentialFlow) = SequentialFlow([prompt; flow.steps])
→(flow::SequentialFlow, prompt::AbstractPrompt) = SequentialFlow([flow.steps; prompt])

→(model::AbstractLangModel, process::AbstractProcess) = SequentialFlow([model, process])
→(model::AbstractLangModel, flow::SequentialFlow) = SequentialFlow([model; flow.steps])
→(flow::SequentialFlow, model::AbstractLangModel) = SequentialFlow([flow.steps; model])

→(process::AbstractProcess, prompt::AbstractPrompt) = SequentialFlow([process, prompt])
→(process::AbstractProcess, flow::SequentialFlow) = SequentialFlow([process; flow.steps])
→(flow::SequentialFlow, process::AbstractProcess) = SequentialFlow([flow.steps; process])

# base functions to provide interaction with SequentialFlow
Base.length(s::SequentialFlow) = length(s.steps)
Base.iterate(s::SequentialFlow, args...) = iterate(s.steps, args...)
Base.getindex(s::SequentialFlow, i) = getindex(s.steps, i)
Base.firstindex(s::SequentialFlow) = firstindex(s.steps)
Base.lastindex(s::SequentialFlow) = lastindex(s.steps)
Base.show(io::IO, s::SequentialFlow) = print(io, join(s.steps, " → "))

function execute(s::SequentialFlow, ctx::AbstractContext)::AbstractContext
    for step in s.steps
        ctx = execute(step, ctx)
    end

    return ctx
end
