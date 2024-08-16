include("../src/BotFlow.jl")
using .BotFlow
using DotEnv
DotEnv.load!()

model = AnthropicChat(
    api_key = ENV["ANTHROPIC_KEY"],
    model="claude-3-haiku-20240307")

messages = [
    HumanMessage(message = "What is the meaning of life?"), 
    AIMessage(message = "42"),
    HumanMessage(message = "What is the meaning of life?")]

responseMessage, anthropicOutput = BotFlow.invoke(model, messages)

push!(messages, responseMessage)

push!(messages, HumanMessage(message = "Prove it."))

responseMessage, anthropicOutput = BotFlow.invoke(model, messages)