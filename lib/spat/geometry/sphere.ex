defmodule Spat.Geometry.Sphere do
    use Bitwise

    @doc """
      Obtain the indexes of a sphere within the subdivided bounds.

        iex> Spat.Geometry.Sphere.index({ 0 }, 1, Spat.Bounds.new({ 10 }), 1)
        [[0]]

        iex> Spat.Geometry.Sphere.index({ 5 }, 1, Spat.Bounds.new({ 10 }), 1)
        [[0], [1]]

        iex> Spat.Geometry.Sphere.index({ 10 }, 1, Spat.Bounds.new({ 10 }), 1)
        [[1]]

        iex> Spat.Geometry.Sphere.index({ -1 }, 1, Spat.Bounds.new({ 10 }), 1)
        []

        iex> Spat.Geometry.Sphere.index({ 2.5 }, 1, Spat.Bounds.new({ 10 }), 1)
        [[0]]

        iex> Spat.Geometry.Sphere.index({ 2.5 }, 1, Spat.Bounds.new({ 10 }), 2)
        [[0, 0], [0, 1]]

        iex> Spat.Geometry.Sphere.index({ 5, 5 }, 1, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 3], [1, 2], [2, 1], [3, 0]]

        iex> Spat.Geometry.Sphere.index({ 2.5, 5 }, 1, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 2], [0, 3], [2, 0], [2, 1]]

        iex> Spat.Geometry.Sphere.index({ 0, 0 }, 1, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 0]]

        iex> Spat.Geometry.Sphere.index({ 0, 0 }, 20, Spat.Bounds.new({ 10, 10 }), 2)
        [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]]

        iex> Spat.Geometry.Sphere.index({ 12.5, 5 }, 1, Spat.Bounds.new({ 10, 0 }, { 20, 10 }), 2)
        [[0, 2], [0, 3], [2, 0], [2, 1]]

        iex> Spat.Geometry.Sphere.index({ 10, 0 }, 1, Spat.Bounds.new({ 10, 0 }, { 20, 10 }), 2)
        [[0, 0]]

        iex> Spat.Geometry.Sphere.index({ 0 }, 1, Spat.Bounds.new({ -10 }, { 10 }), 1)
        [[0], [1]]

        iex> Spat.Geometry.Sphere.index({ -5 }, 1, Spat.Bounds.new({ -10 }, { 10 }), 2)
        [[0, 0], [0, 1]]
    """
    @spec index(Spat.Coord.t, number, Spat.Bounds.t, pos_integer) :: [Spat.grid_index]
    def index(origin, radius, bounds, subdivisions), do: Spat.Geometry.index(&intersect(origin, radius, &1), bounds, subdivisions)

    @doc """
      Check whether a sphere intersects with the given bounds (equal to or contained
      inside).
    """
    @spec intersect(Spat.Coord.t, number, Spat.Bounds.t) :: boolean
    def intersect(origin, radius, %{ min: min, max: max, dimension: dimension }), do: intersect(origin, radius, min, max, dimension)

    @doc false
    @spec intersect(Spat.Coord.t, number, Spat.Coord.t, Spat.Coord.t, non_neg_integer, number) :: boolean
    defp intersect(origin, radius, min, max, dimension, dist2 \\ 0)
    defp intersect(_, radius, _, _, 0, dist2), do: dist2 < (radius * radius)
    defp intersect(origin, radius, min, max, dimension, dist2) do
        axis = dimension - 1
        p = Spat.Coord.get(origin, axis)
        start = Spat.Coord.get(min, axis)
        stop = Spat.Coord.get(max, axis)

        closest = min(max(p, start), stop)
        distance = p - closest
        dist2 = dist2 + (distance * distance)

        intersect(origin, radius, min, max, axis, dist2)
    end
end
