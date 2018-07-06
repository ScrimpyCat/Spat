defmodule Spat.Geometry.Point do
    use Bitwise

    @behaviour Spat.Geometry

    @impl Spat.Geometry
    def index(point, { bound_min, bound_max }, subdivisions) do
        dimension = Spat.Coord.dimension(point)
        vertices = (1 <<< dimension)

        index(point, bound_min, bound_max, subdivisions, dimension, 0..(vertices - 1))
        |> flatten
    end

    def index(_, _, _, 0, _, _), do: []
    def index(point, bound_min, bound_max, subdivisions, dimension, vertices) do
        Enum.map(vertices, fn region ->
            { min, max } = subdivide(bound_min, bound_max, dimension, region)

            if intersect(point, min, max, dimension) do
                case flat_insert(region, index(point, min, max, subdivisions - 1, dimension, vertices)) do
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

    defp flat_insert(region, []), do: []
    defp flat_insert(region, [[]|list]), do: flat_insert(region, list)
    defp flat_insert(region, [head|list]) when is_list(head), do: [flat_insert(region, head)|flat_insert(region, list)]
    defp flat_insert(region, list), do: [region|list]

    defp subdivide(min, max, dimension, region, sub \\ { [], [] })
    defp subdivide(_, _, 0, _, sub), do: sub
    defp subdivide(min, max, dimension, region, { sub_min, sub_max }) do
        axis = dimension - 1
        start = Spat.Coord.get(min, axis)
        stop = (Spat.Coord.get(max, axis) - start) / 2
        start = if(((region >>> axis) &&& 1) == 1, do: start + stop, else: start)

        subdivide(min, max, axis, region, { [start|sub_min], [(stop + start)|sub_max] })
    end

    def intersect(_, _, _, 0), do: true
    def intersect(point, min, max, dimension) do
        axis = dimension - 1
        p = Spat.Coord.get(point, axis)
        start = Spat.Coord.get(min, axis)
        stop = Spat.Coord.get(max, axis)

        if (start <= p) && (stop >= p) do
            intersect(point, min, max, axis)
        else
            false
        end
    end
end
