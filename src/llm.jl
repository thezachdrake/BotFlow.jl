abstract type AbstractLangModel end
abstract type AbstractModelOutput end

abstract type AbstractChatModel <: AbstractLangModel end

abstract type AbstractTextModel <: AbstractLangModel end

function invoke(model::AbstractLangModel, args...; kwargs...)::AbstractModelOutput
    return "Please provide a concrete implementation of AbstractLangModel"
end