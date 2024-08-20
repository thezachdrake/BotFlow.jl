"""
    SequentialContext

Each step will take in the context, perform some action, and then return the context.
"""

@kwdef mutable struct SequentialContext <: AbstractContext
    prompt::String = ""
    messages::Vector{AbstractMessage} = []
    steps::Vector{Union{AbstractPromptTemplate,AbstractLangModel,AbstractProcess}} = []
    data::Vector{Pair{Symbol,Any}} = []
    results::Vector{AbstractModelOutput} = []
    params::Vector{Pair{Symbol,Any}} = []
end
