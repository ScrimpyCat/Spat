defmodule Spat.MixProject do
    use Mix.Project

    def project do
        [
            app: :spat,
            version: "0.1.0",
            elixir: "~> 1.6",
            start_permanent: Mix.env() == :prod,
            deps: deps(),
            dialyzer: [plt_add_deps: :transitive]
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [extra_applications: [:logger]]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [{ :itsy, "~> 0.0" }]
    end
end
