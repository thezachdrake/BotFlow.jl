include("message.jl")
include("tool.jl")
include("process.jl")
include("llm.jl")
include("prompt.jl")

abstract type AbstractContext end

"""
    SequentialContext

Context object to carry the state of the flow between steps.
Each step will take in the context, perform some action, and then return the context. 
"""
@kwdef mutable struct SequentialContext <: AbstractContext
    prompt::String
    messages::Vector{AbstractMessage}
    steps::Vector{Union{AbstractPrompt, AbstractLangModel, AbstractProcess}} = []
    data::Vector{Pair{Symbol, Any}} = [] 
    results::Vector{AbstractModelOutput} = []
    params::Vector{Pair{Symbol, Any}} = []
end