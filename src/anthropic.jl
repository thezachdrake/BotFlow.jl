import HTTP
import JSON3
import Base: @kwdef

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

@kwdef mutable struct AnthropicOutput <: AbstractModelOutput
    id::String
    stop_reason::String = nothing
    stop_sequence::String = nothing
    input_tokens::Int = nothing
    output_tokens::Int = nothing
end

function anthropicRole(role::String)::String
    return role == "human" ? "user" : "assistant"
end

function invoke(
    model::AnthropicChat,
    messages::Vector{AbstractMessage},
    args...;
    kwargs...,
)::(AIMessage, AnthropicOutput)
    @debug "Invoking AnthropicChat $(model.model)"
    const url::String = "https://api.anthropic.com/v1/message"
    @debug "Calling $url"

    const headers::Dict{String, String} = Dict(
        "Content-Type" => "application/json",
        "x-api-key" => model.api_key,
        "anthropic-version" => "2023-06-01",
    )

    body::Dict{String, Any} = Dict(
        "model" => model.model,
        "max_tokens_to_sample" => model.max_tokens,
        "messages" => [
            Dict("role" => anthropicRole(m.role), "content" => m.message) for m in messages
        ],
    )

    if model.temperature != -1.0
        body["temperature"] = model.temperature
        @debug "Setting temperature to $(model.temperature)"
    end
    if model.top_k != -1
        body["top_k"] = model.top_k
        @debug "Setting top_k to $(model.top_k)"
    end
    if model.top_p != -1.0
        body["top_p"] = model.top_p
        @debug "Setting top_p to $(model.top_p)"
    end
    if length(model.stop_sequences) > 0
        body["stop_sequences"] = model.stop_sequences
        @debug "Setting stop_sequences to $(model.stop_sequences)"
    end
    if length(model.tools) > 0
        body["tools"] = model.tools
        @debug "Setting tools to $(model.tools)"
    end

    result::HTTP.Response = HTTP.request(HTTP.post, url, headers, JSON3.write(body))

    if result.status != 200
        @error "Failed to invoke AnthropicChat $(model.model)"
        throw(HTTP.StatusError(result.status, "POST", url, result))
    end

    @debug "Got response from AnthropicChat $(model.model)"
    const response::Dict{String, Any} = JSON3.read(result.body)

    aiMessage = AIMessage(message = response["content"]["text"])
    anthropicOutput = AnthropicOutput(
        id = response["id"],
        stop_reason = response["stop_reason"],
        stop_sequence = response["stop_sequence"],
        input_tokens = response["usage"]["input_tokens"],
        output_tokens = response["usage"]["output_tokens"],
    )

    @info "Recieved message from Anthropic: $(anthropicOutput.id)"
    @info "Message used $(anthropicOutput.input_tokens) input tokens and $(anthropicOutput.output_tokens) output tokens"

    return (aiMessage, anthropicOutput)
end
