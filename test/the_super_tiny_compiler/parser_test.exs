defmodule TheSuperTinyCompiler.ParserTest do
  use ExUnit.Case
  alias TheSuperTinyCompiler.Parser

  test "parser exists" do
    token = %Token{ type: "number", value: "123" }
    Parser.parser([token])
  end

  test "parser can turn a number token into an ast" do
    token = %Token{ type: "number", value: "123" }
    token_node = %Token{ type: "NumberLiteral", value: "123" }
    expected_ast = %Ast{ type: "Program", body: [token_node]}
    assert expected_ast == Parser.parser([token])
  end

  test "parser can parse call expressions" do
    tokens = [
      %Token{ type: "paren",  value: "("},
      %Token{ type: "name", value: "add" },
      %Token{ type: "number", value: "2" },
      %Token{ type: "number", value: "3" },
      %Token{ type: "paren",  value: ")"}
    ]

    expected_ast = %Ast{
      type: "Program",
      body: [%Token{ type: "CallExpression", name: "add",
      params: [ %Token{ type: "NumberLiteral", value: "2"},
                  %Token{type: "NumberLiteral", value: "3"}]
      }]}

      assert expected_ast == Parser.parser(tokens)
  end

  test "parser can parse nested call expressions" do
    tokens = [
      %Token{ type: "paren",  value: "("        },
      %Token{ type: "name",   value: "add"      },
      %Token{ type: "number", value: "2"        },
      %Token{ type: "paren",  value: "("        },
      %Token{ type: "name",   value: "subtract" },
      %Token{ type: "number", value: "4"        },
      %Token{ type: "number", value: "2"        },
      %Token{ type: "paren",  value: ")"        },
      %Token{ type: "paren",  value: ")"        }
    ]

    expected_ast = %Ast{
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

    assert expected_ast == Parser.parser(tokens)
  end
end