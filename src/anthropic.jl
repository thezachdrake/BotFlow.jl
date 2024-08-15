include("llm.jl")
include("tools.jl")
include("message.jl")

@kwdef mutable struct AnthropicTool <: AbstractTool
    name::String
    description::String
    args::Vector{String}
end

@kwdef mutable struct AnthropicChat <: AbstractChatModel
    api_key::String
    model::String
    max_tokens::Int = 1024
    temperature::Float64 = 0.5
    stop_sequences::Vector{String} = []
    tools::Vector{AnthropicTool} = []
    top_k::Int = -1
    top_p::Float64 = -1.0
end

@kwdef mutable struct AnthropicOutput <: AbstractModelOutput end

function invoke(
    model::AnthropicChat,
    messages::Vector{AbstractMessage},
    args...;
    kwargs...,
)::AnthropicOutput
    const url::String = "https://api.anthropic.com/v1/message"

    const headers::Dict{String, String} = Dict(
        "Content-Type" => "application/json",
        "x-api-key" => model.api_key,
        "anthropic-version" => "2023-06-01",
    )

    body::Dict{String, Any} = Dict(
        "model" => model.model,
        "max_tokens_to_sample" => model.max_tokens,
        "messages" =>
            [Dict("role" => m.role, "content" => m.message) for m in messages],
    )

    if model.temperature != -1.0
        body["temperature"] = model.temperature
    end
    if model.top_k != -1
        body["top_k"] = model.top_k
    end
    if model.top_p != -1.0
        body["top_p"] = model.top_p
    end
    if length(model.stop_sequences) > 0
        body["stop_sequences"] = model.stop_sequences
    end
    if length(model.tools) > 0
        body["tools"] = model.tools
    end

    return AnthropicOutput()
end
