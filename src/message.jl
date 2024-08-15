abstract type AbstractMessage end

@kwdef mutable struct HumanMessage <: AbstractMessage
    message::String
    role::String = "user"
end

@kwdef mutable struct AIMessage <: AbstractMessage
    message::String
    role::String = "ai"
end