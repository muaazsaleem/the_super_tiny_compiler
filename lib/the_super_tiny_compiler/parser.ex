defmodule TheSuperTinyCompiler.Parser do
  def parser(tokens) do
    parser(tokens, %Ast{})
  end

  def parser([], ast)  do
    ast
  end

  def parser([%Token{ type: "number", value: number_val } | rest], ast) do
    number_node = %Token{ type: "NumberLiteral", value: number_val }
    parser(rest, %Ast{type: "Program", body: [number_node | ast.body]})
  end

  def parser([%Token{ type: "paren", value: "(" } | rest], ast)  do
    [call_name | params] = rest
    {call_ast, rest } = parser(params)
    call_node = %Token{ type: "CallExpression", name: call_name.value, params: Enum.reverse(call_ast.body)}
    parser(rest, %Ast{type: "Program", body: [call_node | ast.body]})
  end

  def parser([%Token{ type: "paren", value: ")" } | rest], ast) do
    {ast, rest}
  end
end