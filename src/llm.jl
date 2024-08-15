abstract type AbstractLangModel end
abstract type AbstractModelOutput end

abstract type AbstractChatModel <: AbstractLangModel end

abstract type AbstractTextModel <: AbstractLangModel end

function invoke(model::AbstractLangModel)::(AbstractMessage, AbstractModelOutput) end
