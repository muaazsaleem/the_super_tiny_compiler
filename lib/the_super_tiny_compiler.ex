defmodule TheSuperTinyCompiler do
  def tockenizer(input) do
    tockenizer(String.codepoints(input), [])
  end

  def tockenizer(input, tokens) do
    if input == [] do
      tokens
    else
      [char | rest ] = input
      cond do
        char == "(" || char == ")" ->
          token = %Token{ type: "paren", value: char }
          tockenizer(rest, [token | tokens])

        Regex.match?(~r/\s+/, char) ->
          tockenizer(rest, tokens)

        Regex.match?(~r/\d+/, char) ->
          number = Enum.take_while(input, &(Regex.match?(~r/\d+/, &1)))
          not_number_rest = Enum.drop_while(input, &(Regex.match?(~r/\d+/, &1)))
          token = %Token{ type: "number", value: Enum.join(number)}
          tockenizer(not_number_rest, [token | tokens])

        Regex.match?(~r/[a-z]/i, char) ->
          name = Enum.take_while(input, &(Regex.match?(~r/[a-z]/i, &1)))
          not_name_rest = Enum.drop_while(input, &(Regex.match?(~r/[a-z]/i, &1)))
          token = %Token{ type: "name", value: Enum.join(name)}
          tockenizer(not_name_rest, [token | tokens])

        true ->
          raise BadTokenError, message: "I dont know what this character is: #{char}"
      end
    end
  end

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
