defmodule TheSuperTinyCompiler.TockenizerTest do
  use ExUnit.Case
  alias TheSuperTinyCompiler.Tockenizer

  test "tockenizer exists" do
    Tockenizer.tockenizer("(")
  end

  test "tockenizer can turn ( to  Token struct" do
    token = %Token{ type: "paren", value: "(" }
    assert [token] == Tockenizer.tockenizer("(")
  end

  test "tockenizer can ignore whitespace" do
    token = %Token{ type: "paren", value: ")" }
    assert [token] == Tockenizer.tockenizer(") ")
  end

  test "tockenizer can turn numbers into Token struct" do
    token = %Token{ type: "number", value: "123" }
    assert [token] == Tockenizer.tockenizer("123")
  end

  test "tockenizer can turn names into Token struct" do
    token = %Token{ type: "name", value: "add" }
    assert [token] == Tockenizer.tockenizer("add")
  end

  test "tockenizer throws an exception for undefined token" do
    exception = try do
     Tockenizer.tockenizer("_")
    rescue
      BadTokenError -> "got an exception"
    end
    assert exception == "got an exception"
  end

  test "tockenizer can tokenize an expression" do
    input = "(add 2 3)"
    tokens = [
      %Token{ type: "paren",  value: "("},
      %Token{ type: "name", value: "add" },
      %Token{ type: "number", value: "2" },
      %Token{ type: "number", value: "3" },
      %Token{ type: "paren",  value: ")"}
    ]
    assert tokens == Tockenizer.tockenizer(input)
  end
end