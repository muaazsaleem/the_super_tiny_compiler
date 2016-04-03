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

end
