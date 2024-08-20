module BotFlowCore

include("interface.jl")
include("message.jl")
include("prompt.jl")
include("tool.jl")
include("process.jl")
include("context.jl")
include("flow.jl")  # for SequentialFlow


import Base: @kwdef
import HTTP
import JSON3

export HumanMessage,
    AIMessage,
    ProcessMessage,
    AbstractMessage,
    SequentialContext,
    execute,
    SystemPromptTemplate,
    AbstractLangModel,
    AbstractContext,
    AbstractTool,
    AbstractChatModel,
    AbstractPromptTemplate,
    AbstractProcess,
    AbstractFlow,
    SequentialFlow,
    AbstractModelOutput

end

