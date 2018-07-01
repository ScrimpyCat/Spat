defprotocol Spat.Coord do
    def get(coord, axis)

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
