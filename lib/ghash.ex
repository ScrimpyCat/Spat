defmodule GHash do
    @type grid_index :: [non_neg_integer]
    @type packed_grid_index :: bitstring
    @type subdivision(index) :: [index, ...]

    @doc """
      Pack a list (all subdivisions of a level) of grid indexes into a bitstring.

      Dimensionality of the indexes is inferred from the list. So this list
      must be a power of 2, and must contain a grid index for each node of
      the subdivision for a given level.

        iex> GHash.pack([[0], [], [0, 0, 0, 0], [1, 2, 3, 4]])
        [<<0 :: 2>>, <<>>, <<0 :: 8>>, <<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>]
    """
    @spec pack(subdivision(grid_index)) :: subdivision(packed_grid_index)
    def pack(indexes), do: Enum.map(indexes, &pack(&1, Itsy.Bit.count(Itsy.Bit.mask_lower_power_of_2(length(indexes)))))

    @doc """
      Pack a grid index into a bitstring.

        iex> GHash.pack([0], 2)
        <<0 :: 2>>

        iex> GHash.pack([0], 3)
        <<0 :: 3>>

        iex> GHash.pack([], 2)
        <<>>

        iex> GHash.pack([0, 0, 0, 0], 2)
        <<0 :: 8>>

        iex> GHash.pack([1, 2, 3, 4], 2)
        <<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>

        iex> GHash.pack([1, 2, 3, 4], 3)
        <<4 :: 3, 3 :: 3, 2 :: 3, 1 :: 3>>

        iex> GHash.pack([1, 2, 3, 4000], 12)
        <<4000 :: 12, 3 :: 12, 2 :: 12, 1 :: 12>>
    """
    @spec pack(grid_index, pos_integer) :: packed_grid_index
    def pack(index, dimensions) do
        Enum.reduce(index, <<>>, fn index, pack ->
            <<index :: size(dimensions), pack :: bitstring>>
        end)
    end

    @doc """
      Unpack a list (all subdivisions of a level) of grid indexes from a bitstring.

      Dimensionality of the indexes is inferred from the list. So this list
      must be a power of 2, and must contain a packed grid index for each node of
      the subdivision for a given level.

        iex> GHash.unpack([<<0 :: 2>>, <<>>, <<0 :: 8>>, <<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>])
        [[0], [], [0, 0, 0, 0], [1, 2, 3, 0]]
    """
    @spec unpack(subdivision(packed_grid_index)) :: subdivision(grid_index)
    def unpack(indexes), do: Enum.map(indexes, &unpack(&1, Itsy.Bit.count(Itsy.Bit.mask_lower_power_of_2(length(indexes)))))

    @doc """
      Unpack a grid index from a bitstring.

        iex> GHash.unpack(<<0 :: 2>>, 2)
        [0]

        iex> GHash.unpack(<<0 :: 3>>, 3)
        [0]

        iex> GHash.unpack(<<>>, 2)
        []

        iex> GHash.unpack(<<0 :: 8>>, 2)
        [0, 0, 0, 0]

        iex> GHash.unpack(<<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>, 2)
        [1, 2, 3, 0]

        iex> GHash.unpack(<<4000 :: 12, 3 :: 12, 2 :: 12, 1 :: 12>>, 12)
        [1, 2, 3, 4000]
    """
    @spec unpack(packed_grid_index, pos_integer) :: grid_index
    def unpack(index, dimensions), do: unpack(index, dimensions, [])

    defp unpack(<<>>, _, unpacked_index), do: unpacked_index
    defp unpack(packed_index, dimensions, unpacked_index) do
        <<index :: size(dimensions), packed_index :: bitstring>> = packed_index
        unpack(packed_index, dimensions, [index|unpacked_index])
    end
end
