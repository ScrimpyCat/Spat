defmodule Spat.Geometry do
    use Bitwise

    @doc false
    @spec index(any, Spat.Bounds.t, pos_integer, ((any, Spat.Bounds.t) -> boolean)) :: [Spat.grid_index]
    def index(geometry, bounds = %{ dimension: dimension }, subdivisions, intersect) do
        vertices = (1 <<< dimension)

        index(geometry, bounds, subdivisions, 0..(vertices - 1), intersect)
        |> flatten
    end

    @spec index(any, Spat.Bounds.t, non_neg_integer, Range.t, ((any, Spat.Bounds.t) -> boolean)) :: [Spat.grid_index]
    defp index(_, _, 0, _, _), do: []
    defp index(geometry, bounds, subdivisions, vertices, intersect) do
        Enum.map(vertices, fn region ->
            bounds = Spat.Bounds.subdivide(bounds, region)

            if intersect.(geometry, bounds) do
                case flat_insert(region, index(geometry, bounds, subdivisions - 1, vertices, intersect)) do
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
