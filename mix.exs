defmodule HashList.Mixfile do
  use Mix.Project

  def project do
    [app: :hash_list,
     version: "0.0.1",
     elixir: "~> 1.0",
     package: package,
     description: "Unordered, managed/unique/reusable/integer-based index key-value storage"]
  end

  defp package do
    [contributors: ["trapped"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/trapped/elixir-hash_list"}]
  end
end
