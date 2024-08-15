include("llm.jl")

@kwdef mutable struct Anthropic <: AbstractChatModel
    api_key::String
    model::String
    max_tokens::Int
    temperature::Float64
end
