defmodule TheSuperTinyCompiler.CodeGenerator do

  def code_generator(%{type: "NumberLiteral", value: value}) do
    value
  end

  def code_generator(%{type: "CallExpression"} = call_token) do
    args = Enum.map(call_token.arguments, &code_generator/1) |> Enum.join(", ")
    "#{call_token.callee.name}(#{args})"
  end

  def code_generator(%{type: "Program", body: body}) do
    body
    |> Enum.map(&code_generator/1)
    |> Enum.join("\n")
  end
end