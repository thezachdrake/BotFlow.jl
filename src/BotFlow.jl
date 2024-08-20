module BotFlow

export BotFlowCore, BotFlowAnthropic

include("core/BotFlowCore.jl")
include("integrations/Anthropic.jl")

end