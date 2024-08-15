abstract type AbstractLangModel end

abstract type AbstractChatModel <: AbstractLangModel end

abstract type AbstractTextModel <: AbstractLangModel end

function invoke(model::AbstractLangModel, args...; kwargs...)
    return println("invoked")
end