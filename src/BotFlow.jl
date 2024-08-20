module BotFlow

include("message.jl")
include("llm.jl")
include("tool.jl")
include("prompt.jl")
include("process.jl")
include("context.jl")
include("flow.jl")  # for SequentialFlow
include("interface.jl")

import Base: @kwdef
import HTTP
import JSON3

export HumanMessage,
    AIMessage,
    ProcessMessage,
    AbstractMessage,
    SequentialContext,
    execute,
    SystemPromptTemplate
AbstractLangModel, AbstractContext

end
