defmodule Spat.Geometry do
    use Bitwise

    @doc false
    @spec subdivide(Spat.Coord.t, Spat.Coord.t, non_neg_integer, non_neg_integer, { [number], [number] }) :: { Spat.Coord.t, Spat.Coord.t }
    def subdivide(min, max, dimension, region, sub \\ { [], [] })
    def subdivide(_, _, 0, _, sub), do: sub
    def subdivide(min, max, dimension, region, { sub_min, sub_max }) do
        axis = dimension - 1
        start = Spat.Coord.get(min, axis)
        stop = (Spat.Coord.get(max, axis) - start) / 2
        start = if(((region >>> axis) &&& 1) == 1, do: start + stop, else: start)

        subdivide(min, max, axis, region, { [start|sub_min], [(stop + start)|sub_max] })
    end
end
