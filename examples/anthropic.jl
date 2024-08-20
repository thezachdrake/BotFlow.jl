using BotFlow

@kwdef mutable struct AnthropicTool <: AbstractTool
    name::String
    description::String
    args::Vector{String}
end

"""
    AnthropicChat <: AbstractChatModel

Implimentation of the `AbstractChatModel` for the Anthropic API.
See https://docs.anthropic.com/en/api/messages for more information.
"""
@kwdef struct AnthropicChat <: AbstractChatModel
    api_key::String
    model::String
    max_tokens::Int = 1024
    temperature::Float64 = 0.5
end

@kwdef struct AnthropicOutput <: AbstractModelOutput
    id::String
    stop_reason::String
    stop_sequence::Union{Nothing, String}
    input_tokens::Int
    output_tokens::Int
end

function anthropicRole(message::AbstractMessage)::String
    if isa(message, HumanMessage)
        return "user"
    elseif isa(message, AIMessage)
        return "assistant"
    elseif isa(message, ProcessMessage)
        return "user"
    end
end

function execute(model::AnthropicChat, ctx::AbstractContext)
    @debug "Invoking AnthropicChat $(model.model)"
    url::String = "https://api.anthropic.com/v1/messages"
    @debug "Calling $url"

    headers::Dict{String, String} = Dict(
        "Content-Type" => "application/json",
        "x-api-key" => model.api_key,
        "anthropic-version" => "2023-06-01",
    )

    body::Dict{String, Any} = Dict(
        "model" => model.model,
        "max_tokens" => model.max_tokens,
        "messages" => [
            Dict("role" => anthropicRole(m), "content" => m.message) for m in ctx.messages
        ],
    )

    result::HTTP.Response = HTTP.request("POST", url, headers, JSON3.write(body))

    if result.status != 200
        @error "Failed to invoke AnthropicChat $(model.model)"
        throw(HTTP.StatusError(result.status, "POST", url, result))
    end

    @debug "Got response from AnthropicChat $(model.model)"
    response = JSON3.read(result.body)
    @debug response

    content = response["content"]
    for c in content
        if c["type"] == "text"
            push!(ctx.messages, AIMessage(message = c["text"]))
        end
    end

    anthropicOutput = AnthropicOutput(
        id = response["id"],
        stop_reason = get(response, "stop_reason", missing),
        stop_sequence = get(response, "stop_sequence", missing),
        input_tokens = response["usage"]["input_tokens"],
        output_tokens = response["usage"]["output_tokens"],
    )

    push!(ctx.results, anthropicOutput)

    @info "Recieved message from Anthropic: $(anthropicOutput.id)"
    @info "Message used $(anthropicOutput.input_tokens) input tokens and $(anthropicOutput.output_tokens) output tokens"

    return ctx
end