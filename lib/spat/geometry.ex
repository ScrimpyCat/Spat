defmodule Spat.Geometry do
    use Bitwise

    @doc false
    @spec index((Spat.Bounds.t -> boolean), Spat.Bounds.t, pos_integer) :: [Spat.grid_index]
    def index(intersect, bounds = %{ dimension: dimension }, subdivisions) do
        vertices = (1 <<< dimension)

        index(intersect, bounds, subdivisions, 0..(vertices - 1))
        |> flatten
    end

    @spec index((Spat.Bounds.t -> boolean), Spat.Bounds.t, non_neg_integer, Range.t) :: [Spat.grid_index]
    defp index(_, _, 0, _), do: []
    defp index(intersect, bounds, subdivisions, vertices) do
        Enum.map(vertices, fn region ->
            bounds = Spat.Bounds.subdivide(bounds, region)

            if intersect.(bounds) do
                case flat_insert(region, index(intersect, bounds, subdivisions - 1, vertices)) do
                    [] -> [region]
                    indexes -> indexes
                end
            else
                []
            end
        end)
    end

    defp flatten(list, flat \\ [])
    defp flatten([], flat), do: flat
    defp flatten([head|list], flat) when is_list(head), do: flatten(head, flatten(list, flat))
    defp flatten(list, flat), do: [list|flat]

    defp flat_insert(_, []), do: []
    defp flat_insert(region, [[]|list]), do: flat_insert(region, list)
    defp flat_insert(region, [head|list]) when is_list(head), do: [flat_insert(region, head)|flat_insert(region, list)]
    defp flat_insert(region, list), do: [region|list]
end
