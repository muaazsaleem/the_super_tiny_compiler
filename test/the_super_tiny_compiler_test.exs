defmodule TheSuperTinyCompilerTest do
  use ExUnit.Case
  doctest TheSuperTinyCompiler

  test "tockenizer exists" do
    TheSuperTinyCompiler.tockenizer("(")
  end

  test "tockenizer can turn ( to  Token struct" do
    token = %Token{ type: "paren", value: "(" }
    assert [token] == TheSuperTinyCompiler.tockenizer("(")
  end

  test "tockenizer can ignore whitespace" do
    token = %Token{ type: "paren", value: ")" }
    assert [token] == TheSuperTinyCompiler.tockenizer(") ")
  end

  test "tockenizer can turn numbers into Token struct" do
    token = %Token{ type: "number", value: "123" }
    assert [token] == TheSuperTinyCompiler.tockenizer("123")
  end

  test "tockenizer can turn names into Token struct" do
    token = %Token{ type: "name", value: "add" }
    assert [token] == TheSuperTinyCompiler.tockenizer("add")
  end

  test "tockenizer throws an exception for undefined token" do
    exception = try do
      TheSuperTinyCompiler.tockenizer("_")
    rescue
      BadTokenError -> "got an exception"
    end
    assert exception == "got an exception"
  end

  test "parser exists" do
    token = %Token{ type: "number", value: "123" }
    TheSuperTinyCompiler.parser([token])
  end

  test "parser can turn a number token into an ast" do
    token = %Token{ type: "number", value: "123" }
    token_node = %Token{ type: "NumberLiteral", value: "123" }
    expected_ast = %Ast{ type: "Program", body: [token_node]}
    assert expected_ast == TheSuperTinyCompiler.parser([token])
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

      assert expected_ast == TheSuperTinyCompiler.parser(tokens)
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

    assert expected_ast == TheSuperTinyCompiler.parser(tokens)
  end

end
