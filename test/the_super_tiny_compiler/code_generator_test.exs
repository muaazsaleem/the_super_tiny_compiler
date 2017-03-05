defmodule TheSuperTinyCompiler.CodeGeneratorTest do
  use ExUnit.Case
  alias TheSuperTinyCompiler.CodeGenerator

  test "a number token generates a number" do
    number_token = %JSToken{ type: "NumberLiteral", value: "2" }
    assert CodeGenerator.code_generator(number_token) == "2"
  end

  test "a call token generates a call" do
    call_token =
      %JSToken{type: "CallExpression",
          callee: %JSToken{ type: "Identifier", name: "subtract"},
        arguments: [
          %JSToken{type: "NumberLiteral", value: "4"},
          %JSToken{type: "NumberLiteral", value: "2"}
        ]}
    output = "subtract(4, 2)"

    assert CodeGenerator.code_generator(call_token) == output
  end

  test "nested calls generate calls too" do
    call_tokens =
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

    output = "add(2, subtract(4, 2))"
    assert CodeGenerator.code_generator(call_tokens) == output
  end

  test "the whole ast gets generated" do
    ast =
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
    output = "add(2, subtract(4, 2))"
    assert CodeGenerator.code_generator(ast) == output
  end
end