include("../src/BotFlow.jl")
using .BotFlow
using DotEnv
DotEnv.load!()

model = AnthropicChat(
    api_key = ENV["ANTHROPIC_KEY"],
    model="claude-3-haiku-20240307")

context = SequentialContext(
    prompt = "Claude is a helpful AI assistant.",
    messages = [
    HumanMessage(message = "What is the meaning of life?"), 
    AIMessage(message = "42"),
    HumanMessage(message = "What is the meaning of life?")]
)

execute(model, context)