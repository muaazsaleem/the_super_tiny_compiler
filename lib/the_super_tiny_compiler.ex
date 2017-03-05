defmodule TheSuperTinyCompiler do
  alias TheSuperTinyCompiler.Tockenizer
  alias TheSuperTinyCompiler.Parser
  alias TheSuperTinyCompiler.Transformer
  alias TheSuperTinyCompiler.CodeGenerator

  def compile(input) do
    input
    |> Tockenizer.tockenizer
    |> Parser.parser
    |> Transformer.transformer
    |> CodeGenerator.code_generator
  end
end
