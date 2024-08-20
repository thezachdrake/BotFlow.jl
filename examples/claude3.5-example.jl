include("../src/BotFlow.jl")
using .BotFlow
using DotEnv
DotEnv.load!()

model = AnthropicChat(api_key = ENV["ANTHROPIC_KEY"], model = "claude-3-haiku-20240307")

context =
    SequentialContext(messages = [HumanMessage(message = "What is the meaning of life?")])

system_prompt = SystemPromptTemplate(
    "You are an AI assistant. Your name is {{name}}. Please introduce yourselve whenever responding",
)
