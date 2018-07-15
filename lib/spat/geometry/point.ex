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
    def index(point, bounds, subdivisions), do: Spat.Geometry.index(&intersect(point, &1), bounds, subdivisions)

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
