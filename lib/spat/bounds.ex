defmodule Spat.Bounds do
    use Bitwise

    defstruct [:min, :max, :dimension]

    @type t :: %Spat.Bounds{ min: Spat.Coord.t, max: Spat.Coord.t, dimension: non_neg_integer }

    @doc """
      Create a new bounds struct, with min range defaulting to 0.
    """
    @spec new(Spat.Coord.t) :: t
    def new(max) do
        dimension = Spat.Coord.dimension(max)

        Stream.iterate(0, &(&1))
        |> Enum.take(dimension)
        |> List.to_tuple
        |> new(max, dimension)
    end

    @doc """
      Create a new bounds struct from min to max.
    """
    @spec new(Spat.Coord.t, Spat.Coord.t) :: t
    def new(min, max), do: new(min, max, Spat.Coord.dimension(max))

    defp new(min, max, dimension), do: %Spat.Bounds{ min: min, max: max, dimension: dimension }

    @doc """
      Get the bounds contained in a subdivision of another bounds.
    """
    @spec subdivide(Spat.Bounds.t, non_neg_integer) :: Spat.Bounds.t
    def subdivide(%{ min: min, max: max, dimension: dimension }, region) do
        { sub_min, sub_max } = subdivide(min, max, dimension, region)
        new(sub_min, sub_max, dimension)
    end

    @doc false
    @spec subdivide(Spat.Coord.t, Spat.Coord.t, non_neg_integer, non_neg_integer, { [number], [number] }) :: { Spat.Coord.t, Spat.Coord.t }
    defp subdivide(min, max, dimension, region, sub \\ { [], [] })
    defp subdivide(_, _, 0, _, sub), do: sub
    defp subdivide(min, max, dimension, region, { sub_min, sub_max }) do
        axis = dimension - 1
        start = Spat.Coord.get(min, axis)
        stop = (Spat.Coord.get(max, axis) - start) / 2
        start = if(((region >>> axis) &&& 1) == 1, do: start + stop, else: start)

        subdivide(min, max, axis, region, { [start|sub_min], [(stop + start)|sub_max] })
    end
end
