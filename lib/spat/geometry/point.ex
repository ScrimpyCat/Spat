defmodule Spat.Geometry.Point do
    use Bitwise

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
