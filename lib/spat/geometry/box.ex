defmodule Spat.Geometry.Box do
    use Bitwise

    @doc """
      Obtain the indexes of a box within the subdivided bounds.

        iex> Spat.Geometry.Box.index({ 0 }, { 1 }, Spat.Bounds.new({ 10 }), 1)
        [[0]]

        iex> Spat.Geometry.Box.index({ 5 }, { 6 }, Spat.Bounds.new({ 10 }), 1)
        [[0], [1]]

        iex> Spat.Geometry.Box.index({ 10 }, { 11 }, Spat.Bounds.new({ 10 }), 1)
        [[1]]

        iex> Spat.Geometry.Box.index({ -1 }, { -0.5 }, Spat.Bounds.new({ 10 }), 1)
        []

        iex> Spat.Geometry.Box.index({ 2.5 }, { 3 }, Spat.Bounds.new({ 10 }), 1)
        [[0]]

        iex> Spat.Geometry.Box.index({ 2.5 }, { 3 }, Spat.Bounds.new({ 10 }), 2)
        [[0, 0], [0, 1]]

        iex> Spat.Geometry.Box.index({ 5, 5 }, { 6, 6 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 3], [1, 2], [2, 1], [3, 0]]

        iex> Spat.Geometry.Box.index({ 2.5, 5 }, { 3, 6 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 2], [0, 3], [2, 0], [2, 1]]

        iex> Spat.Geometry.Box.index({ 0, 0 }, { 1, 1 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 0]]

        iex> Spat.Geometry.Box.index({ 12.5, 5 }, { 13.5, 6 }, Spat.Bounds.new({ 10, 0 }, { 20, 10 }), 2)
        [[0, 2], [0, 3], [2, 0], [2, 1]]

        iex> Spat.Geometry.Box.index({ 10, 0 }, { 11, 1 }, Spat.Bounds.new({ 10, 0 }, { 20, 10 }), 2)
        [[0, 0]]

        iex> Spat.Geometry.Box.index({ 0 }, { 1 }, Spat.Bounds.new({ -10 }, { 10 }), 1)
        [[0], [1]]

        iex> Spat.Geometry.Box.index({ -5 }, { -4 }, Spat.Bounds.new({ -10 }, { 10 }), 2)
        [[0, 0], [0, 1]]

        iex> Spat.Geometry.Box.index({ 11, 1 }, { 50, 50 }, Spat.Bounds.new({ 10, 10 }), 2)
        []

        iex> Spat.Geometry.Box.index({ -25, -25 }, { 50, 50 }, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]]
    """
    @spec index(Spat.Coord.t, Spat.Coord.t, Spat.Bounds.t, pos_integer) :: [Spat.grid_index]
    def index(min, max, bounds, subdivisions), do: Spat.Geometry.index(&intersect(min, max, &1), bounds, subdivisions)

    @doc """
      Check whether a box intersects with the given bounds (equal to or contained
      inside).
    """
    @spec intersect(Spat.Coord.t, Spat.Coord.t, Spat.Bounds.t) :: boolean
    def intersect(box_min, box_max, %{ min: min, max: max, dimension: dimension }), do: intersect(box_min, box_max, min, max, dimension)

    @doc false
    @spec intersect(Spat.Coord.t, Spat.Coord.t, Spat.Coord.t, Spat.Coord.t, non_neg_integer) :: boolean
    defp intersect(_, _, _, _, 0), do: true
    defp intersect(box_min, box_max, min, max, dimension) do
        axis = dimension - 1
        box_start = Spat.Coord.get(box_min, axis)
        box_stop = Spat.Coord.get(box_max, axis)
        start = Spat.Coord.get(min, axis)
        stop = Spat.Coord.get(max, axis)

        if (box_start <= stop) && (box_stop >= start) do
            intersect(box_min, box_max, min, max, axis)
        else
            false
        end
    end
end
