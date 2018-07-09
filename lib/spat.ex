defmodule Spat do
    require Itsy.Binary
    use Bitwise

    @type grid_index :: [non_neg_integer]
    @type packed_grid_index :: bitstring
    @type encoded_index :: String.t
    @type address_modes :: :clamp | :wrap

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

      The encoding is a URL safe string. While the encoding is equivalent to the
      `Base` module's URL-safe base64 encoding (without padding), care should be
      taken if using those functions to encode/decode packed grid indexes. As packed
      grid indexes are bitstrings and not binaries, using the `Base` module variants
      (or other third party base64 functions) may result in losing information.

      If you do have a workflow that requires it to be compatible with base64
      implementations, then it is recommended you pad the packed grid index so
      it's now a binary.

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

    @doc """
      Get the bounds a grid index references.

      iex> bounds = Spat.Bounds.new({ 10, 10 })
      ...> point = {2.6,0}
      ...> subsivisions = 2
      ...> indexes = Spat.Geometry.Point.index(point, bounds, subsivisions)
      ...> Enum.map(indexes, &Spat.to_bounds(&1, bounds))
      [Spat.Bounds.new([2.5, 0], [5.0, 2.5])]

      iex> Spat.to_bounds([0], Spat.Bounds.new({ 10, 10 }))
      Spat.Bounds.new([0, 0], [5.0, 5.0])

      iex> Spat.to_bounds([1], Spat.Bounds.new({ 10, 10 }))
      Spat.Bounds.new([5.0, 0], [10.0, 5.0])

      iex> Spat.to_bounds([2], Spat.Bounds.new({ 10, 10 }))
      Spat.Bounds.new([0, 5.0], [5.0, 10.0])

      iex> Spat.to_bounds([3], Spat.Bounds.new({ 10, 10 }))
      Spat.Bounds.new([5.0, 5.0], [10.0, 10.0])

      iex> Spat.to_bounds([0, 0, 0], Spat.Bounds.new({ 10, 10 }))
      Spat.Bounds.new([0, 0], [1.25, 1.25])
    """
    @spec to_bounds(grid_index, Spat.Bounds.t) :: Spat.Bounds.t
    def to_bounds([], bounds), do: bounds
    def to_bounds([region|index], bounds), do: to_bounds(index, Spat.Bounds.subdivide(bounds, region))

    defp index_to_literals([], literals), do: literals
    defp index_to_literals([region|index], literals) do
        { literals, _ } = Enum.map_reduce(literals, region, &({ (&1 <<< 1) ||| (&2 &&& 1), &2 >>> 1 }))
        index_to_literals(index, literals)
    end

    defp literals_to_index(literals, index, count, axis \\ 0)
    defp literals_to_index([], index, count, axis), do: index
    defp literals_to_index([value|literals], index, count, axis) do
        { index, _ } = Enum.map_reduce(index, count, fn region, sub ->
            { region ||| (((value >>> sub) &&& 1) <<< axis), sub - 1 }
        end)
        literals_to_index(literals, index, count, axis + 1)
    end

    @spec adjacent(grid_index, pos_integer, pos_integer, Spat.Coord.t, address_modes) :: grid_index
    def adjacent(index, dimensions, subdivisions, offset, mode \\ :clamp) do
        { literals, _ } =
            index_to_literals(index, Stream.iterate(0, &(&1)) |> Enum.take(dimensions))
            |> Enum.map_reduce(0, case mode do
                :clamp ->
                    max = Itsy.Bit.set(subdivisions)
                    fn value, axis ->
                        case value + Spat.Coord.get(offset, axis) do
                            total when total > max -> { max, axis + 1 }
                            total when total < 0 -> { 0, axis + 1 }
                            total -> { total, axis + 1 }
                        end
                    end
                :wrap -> &({ &1 + Spat.Coord.get(offset, &2), &2 + 1 })
            end)

        literals_to_index(literals, Stream.iterate(0, &(&1)) |> Enum.take(subdivisions), subdivisions - 1)
    end
end
