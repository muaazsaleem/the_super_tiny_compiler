defmodule TheSuperTinyCompiler.TransformerTest do
  use ExUnit.Case
  alias TheSuperTinyCompiler.Transformer

  test "number token transforme to JSToken" do
    number_token = %Token{ type: "NumberLiteral", value: "2" }
    number_jstoken = %JSToken{ type: "NumberLiteral", value: "2" }
    assert Transformer.transformer(number_token) == number_jstoken
  end

  test "call token is transformed" do
    input_exp_token =
      %Token{type: "CallExpression",
        name: "subtract",
        params: [
          %Token{type: "NumberLiteral", value: "4"},
          %Token{type: "NumberLiteral", value: "2"}
        ]}

    output_exp_token =
      %JSToken{type: "CallExpression",
          callee: %JSToken{ type: "Identifier", name: "subtract"},
        arguments: [
          %JSToken{type: "NumberLiteral", value: "4"},
          %JSToken{type: "NumberLiteral", value: "2"}
        ]}

    assert Transformer.transformer(input_exp_token) == output_exp_token
  end

  test "nested call tokens are transformed" do
    call_tokens =
    %Token{ type: "CallExpression", name: "add",
      params: [
        %Token{ type: "NumberLiteral", value: "2"},
        %Token{ type: "CallExpression", name: "subtract",
          params: [
            %Token{ type: "NumberLiteral", value: "4" },
            %Token{ type: "NumberLiteral", value: "2"}]
        }]}

    exp_call_tokens =
      %JSToken{ type: "CallExpression",
        callee: %JSToken{ type: "Identifier" , name: "add"},
        arguments: [
          %JSToken{ type: "NumberLiteral", value: "2"},
          %JSToken{ type: "CallExpression",
            callee: %JSToken{ type: "Identifier", name: "subtract"},
            arguments: [
              %JSToken{type: "NumberLiteral", value: "4"},
              %JSToken{type: "NumberLiteral", value: "2"}
          ]}]}

    assert Transformer.transformer(call_tokens) == exp_call_tokens
  end

  test "the whole ast gets transformed" do
    ast =
      %Ast{
        type: "Program",
        body: [
          %Token{ type: "CallExpression", name: "add",
            params: [
              %Token{ type: "NumberLiteral", value: "2"},
              %Token{ type: "CallExpression", name: "subtract",
                params: [
                  %Token{ type: "NumberLiteral", value: "4" },
                  %Token{ type: "NumberLiteral", value: "2"}]
              }]
        }]}

    exp_ast =
      %Ast{
        type: "Program",
        body: [
          %JSToken{ type: "CallExpression",
            callee: %JSToken{ type: "Identifier" , name: "add"},
            arguments: [
              %JSToken{ type: "NumberLiteral", value: "2"},
              %JSToken{ type: "CallExpression",
                callee: %JSToken{ type: "Identifier", name: "subtract"},
                arguments: [
                  %JSToken{type: "NumberLiteral", value: "4"},
                  %JSToken{type: "NumberLiteral", value: "2"}
              ]}]}]}

    assert Transformer.transformer(ast) == exp_ast
  end
end





