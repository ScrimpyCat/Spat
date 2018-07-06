defmodule Spat do
    require Itsy.Binary

    @type grid_index :: [non_neg_integer]
    @type packed_grid_index :: bitstring
    @type encoded_index :: String.t

    @doc """
      Pack a grid index into a bitstring.

        iex> Spat.pack([0], 2)
        <<0 :: 2>>

        iex> Spat.pack([0], 3)
        <<0 :: 3>>

        iex> Spat.pack([], 2)
        <<>>

        iex> Spat.pack([0, 0, 0, 0], 2)
        <<0 :: 8>>

        iex> Spat.pack([1, 2, 3, 4], 2)
        <<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>

        iex> Spat.pack([1, 2, 3, 4], 3)
        <<4 :: 3, 3 :: 3, 2 :: 3, 1 :: 3>>

        iex> Spat.pack([1, 2, 3, 4000], 12)
        <<4000 :: 12, 3 :: 12, 2 :: 12, 1 :: 12>>
    """
    @spec pack(grid_index, pos_integer) :: packed_grid_index
    def pack(index, dimensions), do: Itsy.Binary.pack(index, dimensions, reverse: true)

    @doc """
      Unpack a grid index from a bitstring.

        iex> Spat.unpack(<<0 :: 2>>, 2)
        [0]

        iex> Spat.unpack(<<0 :: 3>>, 3)
        [0]

        iex> Spat.unpack(<<>>, 2)
        []

        iex> Spat.unpack(<<0 :: 8>>, 2)
        [0, 0, 0, 0]

        iex> Spat.unpack(<<0 :: 2, 3 :: 2, 2 :: 2, 1 :: 2>>, 2)
        [1, 2, 3, 0]

        iex> Spat.unpack(<<4000 :: 12, 3 :: 12, 2 :: 12, 1 :: 12>>, 12)
        [1, 2, 3, 4000]
    """
    @spec unpack(packed_grid_index, pos_integer) :: grid_index
    def unpack(index, dimensions), do: Itsy.Binary.unpack(index, dimensions, reverse: true)

    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    |> String.graphemes
    |> Enum.with_index
    |> Itsy.Binary.encoder(private: true, encode: :encode_hash, decode: :decode_hash)

    @doc """
      Encode a packed grid index.

        iex> Spat.encode(<<0 :: 2>>)
        "A"

        iex> Spat.encode(<<0 :: 3>>)
        "A"

        iex> Spat.encode(<<0 :: 8>>)
        "AA"

        iex> Spat.encode(<<1 :: 6, 2 :: 6, 3 :: 6>>)
        "BCD"
    """
    @spec encode(packed_grid_index) :: encoded_index
    def encode(index), do: encode_hash(index)

    @doc """
      Decode an encoded packed grid index.

        iex> Spat.decode("A", 2, 1)
        <<0 :: 2>>

        iex> Spat.decode("A", 3, 1)
        <<0 :: 3>>

        iex> Spat.decode("AA", 2, 4)
        <<0 :: 8>>

        iex> Spat.decode("BCD", 6, 3)
        <<1 :: 6, 2 :: 6, 3 :: 6>>
    """
    @spec decode(encoded_index, pos_integer, pos_integer) :: packed_grid_index
    def decode(hash, dimensions, subdivisions) do
        { :ok, index } = decode_hash(hash, bits: true)
        size = subdivisions * dimensions
        <<index :: bitstring-size(size), _ :: bitstring>> = index
        index
    end
end
