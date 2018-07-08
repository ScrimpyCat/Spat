defmodule Spat.Geometry.Point do
    use Bitwise

    @doc """
      Obtain the indexes of a point within the subdivided bounds.

        iex> Spat.Geometry.Point.index({ 0 }, Spat.Bounds.new({ 10 }), 1)
        [[0]]

        iex> Spat.Geometry.Point.index({ 5 }, Spat.Bounds.new({ 10 }), 1)
        [[0], [1]]

        iex> Spat.Geometry.Point.index({ 10 }, Spat.Bounds.new({ 10 }), 1)
        [[1]]

        iex> Spat.Geometry.Point.index({ -1 }, Spat.Bounds.new({ 10 }), 1)
        []

        iex> Spat.Geometry.Point.index({ 2.5 }, Spat.Bounds.new({ 10 }), 1)
        [[0]]

        iex> Spat.Geometry.Point.index({ 2.5 }, Spat.Bounds.new({ 10 }), 2)
        [[0, 0], [0, 1]]

        iex> Spat.Geometry.Point.index({ 5, 5 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 3], [1, 2], [2, 1], [3, 0]]

        iex> Spat.Geometry.Point.index({ 2.5, 5 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 2], [0, 3], [2, 0], [2, 1]]

        iex> Spat.Geometry.Point.index({ 0, 0 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 0]]

        iex> Spat.Geometry.Point.index({ 12.5, 5 }, Spat.Bounds.new({ 10, 0 }, { 20, 10 }), 2)
        [[0, 2], [0, 3], [2, 0], [2, 1]]

        iex> Spat.Geometry.Point.index({ 10, 0 }, Spat.Bounds.new({ 10, 0 }, { 20, 10 }), 2)
        [[0, 0]]

        iex> Spat.Geometry.Point.index({ 0 }, Spat.Bounds.new({ -10 }, { 10 }), 1)
        [[0], [1]]

        iex> Spat.Geometry.Point.index({ -5 }, Spat.Bounds.new({ -10 }, { 10 }), 2)
        [[0, 0], [0, 1]]
    """
    @spec index(Spat.Coord.t, Spat.Bounds.t, pos_integer) :: [Spat.grid_index]
    def index(point, bounds = %{ dimension: dimension }, subdivisions) do
        vertices = (1 <<< dimension)

        index(point, bounds, subdivisions, 0..(vertices - 1))
        |> flatten
    end

    @spec index(Spat.Coord.t, Spat.Bounds.t, non_neg_integer, Range.t) :: [Spat.grid_index]
    defp index(_, _, 0, _), do: []
    defp index(point, bounds, subdivisions, vertices) do
        Enum.map(vertices, fn region ->
            bounds = Spat.Bounds.subdivide(bounds, region)

            if intersect(point, bounds) do
                case flat_insert(region, index(point, bounds, subdivisions - 1, vertices)) do
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

    @doc """
      Check whether a point intersects with the given bounds (equal to or contained
      inside).
    """
    @spec intersect(Spat.Coord.t, Spat.Bounds.t) :: boolean
    def intersect(point, %{ min: min, max: max, dimension: dimension }), do: intersect(point, min, max, dimension)

    @doc false
    @spec intersect(Spat.Coord.t, Spat.Coord.t, Spat.Coord.t, non_neg_integer) :: boolean
    defp intersect(_, _, _, 0), do: true
    defp intersect(point, min, max, dimension) do
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
