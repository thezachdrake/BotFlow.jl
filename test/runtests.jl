using BotFlow
using Test

@testset "BotFlowCore" begin
    @test BotFlowCore.HumanMessage("hello") isa BotFlowCore.HumanMessage
    @test BotFlowCore.AIMessage("hello") isa BotFlowCore.AIMessage
end
