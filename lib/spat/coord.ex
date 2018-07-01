defprotocol Spat.Coord do
    @doc """
      Get the value of a particular axis from the coordinate.

      Axes should be mapped started from `0` to `n` (where `n` is
      `Spat.Coord.dimension(coord) - 1`), where the `0` axis will be
      equivalent to the `x` axis, and `1` will be `y`, etc.
    """
    @spec get(t, non_neg_integer) :: number
    def get(coord, axis)

    @doc """
      Get dimensions of the coordinate.
    """
    @spec dimension(t) :: non_neg_integer
    def dimension(coord)
end

defimpl Spat.Coord, for: Tuple do
    def get(coord, axis), do: elem(coord, axis)

    def dimension(coord), do: tuple_size(coord)
end

defimpl Spat.Coord, for: List do
    def get([value|_], 0), do: value
    def get([_|axes], axis), do: get(axes, axis - 1)

    def dimension(coord), do: length(coord)
end
