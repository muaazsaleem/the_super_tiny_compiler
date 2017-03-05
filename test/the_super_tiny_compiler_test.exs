defmodule TheSuperTinyCompilerTest do
  use ExUnit.Case
  alias TheSuperTinyCompiler, as: Compiler

  test "generates nested expressions" do
    input  = "(add 2 (subtract 4 2))";
    output = "add(2, subtract(4, 2))";
    assert Compiler.compile(input) == output
  end
end
