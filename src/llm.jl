
"""
    AbstractLangModel

Base LLM type on which the core methods can be implemented. Concrete implementations
will exist for different foundation model providers with fields specific to the interface
of that provider's models. 
"""
abstract type AbstractLangModel end

"""
    AbstractModelOutput

Base output type for LLMs. The output contains the information and metadata
returned by the foundation models that does not get implimented in the message. 
Examples include the number of tokens consumed, the stop sequence used, etc.
These outputs provide the ability for analysis of various model runs. 
"""
abstract type AbstractModelOutput end


"""
    AbstractChatModel

Subtype of `AbstractLangModel` that indicates the model is intended to be used with a 
"chat" interface. These models typically take an array of messages and a system prompt 
as inputs and return a message. Most newer models only offer this kind of interface. See 'invoke'
for calling method with a `Vector{AbstractMessage}`.
"""
abstract type AbstractChatModel <: AbstractLangModel end


"""
    AbstractTextModel

Subtype of `AbstractLangModel` that indicates the model is intended to be used with a 
"completion" interface. These models typically take a prompt string as input and 
return a string. This interface is more common on legacy models. Many newer models 
no longer offer this kind of interface. See 'invoke' for calling method with a 
`AbstractPrompt`.
"""
abstract type AbstractTextModel <: AbstractLangModel end

"""
    use(AbstractTextModel, AbstractPrompt)::(Tuple{AbstractMessage, AbstractModelOutput})
    use(AbstractChatModel, Vector{AbstractMessage})::(Tuple{AbstractMessage, AbstractModelOutput})

Takes a `AbstractLangModel` and either a `AbstractPrompt` or `Vector{AbstractMessage}` 
and returns a `Tuple{AbstractMessage, AbstractModelOutput}`.
Implimentation for concrete model types will make HTTP calls
to the model's API. 
"""
function use end

