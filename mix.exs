defmodule EverybodyCodes.MixProject do
  use Mix.Project

  def project do
    [
      app: :everybody_codes,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:combination, "~>  0.0.3"},
      {:memoize, "~> 1.4"},
      # {:deque, "~> 1.2"}, # This does not work with Day 15
      {:complex, "~> 0.4.1"},
      # This is mostly broken. I just use it for priority queues.
      {:libgraph, "~> 0.16.0"}
    ]
  end
end
