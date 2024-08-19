abstract type AbstractContext end

@kwdef mutable struct SequentialContext <: AbstractContext
    prompt::String
    messages::Vector{AbstractMessage}
    steps::Vector{Union{AbstractPrompt, AbstractModel, AbstractProcess}}
    data::Vector{Pair{Symbol, Any}}
    results::Vector{AbstractModelOutput}
    params::Vector{Pair{Symbol, Any}}
end