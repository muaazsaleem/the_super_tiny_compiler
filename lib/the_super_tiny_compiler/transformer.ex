defmodule TheSuperTinyCompiler.Transformer do

  def transformer(%{type: "NumberLiteral"} = number_token) do
    %JSToken{type: number_token.type,
             value: number_token.value}
  end

  def transformer(%{type: "CallExpression"} = call_token) do
    %JSToken{type: "CallExpression",
      callee: %JSToken{type: "Identifier", name: call_token.name},
      arguments: Enum.map(call_token.params, &transformer/1)}
  end

  def transformer(%{type: "Program"} = ast) do
    %{ast | body: Enum.map(ast.body, &transformer/1)}
  end
end