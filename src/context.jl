abstract type AbstractContext end

@kwdef mutable struct SequentialContext <: AbstractContext
    steps::Vector{Union{AbstractPrompt, AbstractModel, AbstractProcess}}
    data::Vector{Any}
    results::Vector{AbstractModelOutput}
end