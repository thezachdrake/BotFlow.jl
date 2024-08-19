module BotFlow

include("message.jl")
include("llm.jl")
include("tool.jl")

include("anthropic.jl")

import Base: @kwdef
 
export 
    AnthropicChat, 
    HumanMessage, 
    AIMessage, 
    ProcessMessage, 
    AbstractMessage,
    SequentialContext, 
    execute

end
