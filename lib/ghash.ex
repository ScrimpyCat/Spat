defmodule GHash do
    @type grid_index :: [non_neg_integer]
    @type subdivision_indexes :: [grid_index, ...]
    @type packed_grid_index :: bitstring

    @doc """
      Pack a list (all subdivisions of a level) of grid indexes into a bitstring.

      Dimensionality of the indexes is inferred from the list. So this list
      must be a power of 2, and must contain a grid index for each node of
      the subdivision for a given level.

        iex> GHash.pack([[0], [], [0, 0, 0, 0], [1, 2, 3, 4]])
        [<<0 :: 2>>, <<>>, <<0 :: 8>>, <<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>]
    """
    @spec pack(subdivision_indexes) :: [packed_grid_index]
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

        iex> GHash.pack([1, 2, 3, 4000], 11)
        <<4000 :: 11, 3 :: 11, 2 :: 11, 1 :: 11>>
    """
    @spec pack(grid_index, pos_integer) :: packed_grid_index
    def pack(index, dimensions) do
        Enum.reduce(index, <<>>, fn index, pack ->
            <<index :: size(dimensions), pack :: bitstring>>
        end)
    end
end
