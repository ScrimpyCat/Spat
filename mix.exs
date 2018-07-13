defmodule Spat.MixProject do
    use Mix.Project

    def project do
        [
            app: :spat,
            version: "0.1.0",
            elixir: "~> 1.6",
            start_permanent: Mix.env() == :prod,
            deps: deps(),
            dialyzer: [plt_add_deps: :transitive],
            docs: [
                main: "readme",
                extras: [
                    "README.md": [filename: "readme", title: "Spat"]
                ],
                markdown_processor_options: [extensions: [SimpleMarkdownExtensionSvgBob]]
            ]
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [extra_applications: [:logger]]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            { :itsy, "~> 0.0" },
            { :ex_doc, "~> 0.18", only: :dev, runtime: false },
            { :simple_markdown, "~> 0.5.3", only: :dev, runtime: false },
            { :ex_doc_simple_markdown, "~> 0.3", only: :dev, runtime: false },
            { :simple_markdown_extension_svgbob, "~> 0.1", only: :dev, runtime: false }
        ]
    end
end
