# Spat

Spat is a spatial hashing library. Used for hashing geometries in linear regions for n-dimensions.

## How it works

#### Indexing

The hashing is based on producing an index of the location of the geometry within a subdivision grid. A way to visualise this for a 2D region can be as follows:

```bob
+-------------+-------------+
|             |             |
|             |             |
|      2      |      3      |
|             |             |
|             |             |
+-------------+-------------+
|             |             |
|             |             |
|      0      |      1      |
|             |             |
|             |             |
+-------------+-------------+
```

The above represents the indices of the first subdivision of this 2D space.

```bob
+-------------+-------------+
|      |      |      |      |
|  2,2 | 2,3  |  3,2 | 3,3  |
| -----+----- | -----+----- |
|  2,0 | 2,1  |  3,0 | 3,1  |
|      |      |      |      |
+-------------+-------------+
|      |      |      |      |
|  0,2 | 0,3  |  1,2 | 1,3  |
| -----+----- | -----+----- |
|  0,0 | 0,1  |  1,0 | 1,1  |
|      |      |      |      |
+-------------+-------------+
```

The above represents the indices of the second subdivision of this 2D space. This process keeps repeating for the desired number of subdivisions.

When calculating the index for a given geometry, it looks up where it is located in the subdivided region and the resulting location(s) is its index.

```bob
                      100,100
+-------------+-------------+
|             |             |
|             |             |
|             |             |
|             |             |
|             |             |
+-------------+-------------+
|             | O    |      |
|             |      |      |
|             | -----+----- |
|             |      |      |
|             |      |      |
+-------------+-------------+
0,0
```

For instance if we have the bounds starting from `0,0` to `100,100`, and working with 2 subdivisions. The geometry of `O = (60,48)` would be located in the bottom right region of the first subdivision, and the top left region of the second subdivision within that. This would mean it would have the index `[1,2]`.

```elixir
bounds = Spat.Bounds.new({ 100, 100 })
point = { 60, 48 }
subdivisions = 2
Spat.Geometry.Point.index(point, bounds, subdivisions)
# => [[1, 2]]
```

While in 3D space it would be adapted as follows:

```bob
      +-------------+-------------+        +-------------+-------------+
     /             /              |       /             /              |
    /      6      /      7      / |      /     1,6     /     1,7     / |
   +-------------+-------------   |     +-------------+-------------   |
  /             /              |  |    /             /              |  |
 /      2      /      3      / |7 |   /     1,2     /     1,3     / 1,7|
+ -- -- -- -- + -- -- -- --    |  +  + -- -- -- -- + -- -- -- --    |  +
|             |             |  | /|  |             |             |  | /|
|             |              3 |/ |  |             |             1,3|/ |
|      2      |      3      |  +  |  |     1,2     |     1,3     |  +  |
|             |               /|  |  |             |               /|  |
|             |             |/ |5 |  |             |             |/ 1,5|
+-------------+-------------+  |  +  +-------------+-------------+  |  +
|             |             |  | /   |             |             |  | /
|             |              1 |/    |             |             1,1|/
|      0      |      1      |  +     |     1,0     |     1,1     |  +
|             |               /      |             |               /
|             |             |/  ->   |             |             |/
+-------------+-------------+        +-------------+-------------+
```

```elixir
bounds = Spat.Bounds.new({ 100, 100, 100 })
point = { 60, 48, 50 }
subdivisions = 2
Spat.Geometry.Point.index(point, bounds, subdivisions)
# => [[1, 6], [5, 2]]
```

This can be scaled up to any dimension, such as 6D or 20D (**note:** While this is possible, this library is currently not optimised for higher dimension work).

```elixir
bounds = Spat.Bounds.new({ 100, 100, 100, 100, 100, 100 })
point = { 60, 48, 0, 0, 0, 50 }
subdivisions = 2
Spat.Geometry.Point.index(point, bounds, subdivisions)
# => [[1, 34], [33, 2]]

dimensions = 20
bounds = Spat.Bounds.new(Stream.repeatedly(fn -> 100 end) |> Enum.take(dimensions))
point = [60, 48|(Stream.repeatedly(fn -> 0 end) |> Enum.take(dimensions - 3)) ++ [50]]
subdivisions = 2
Spat.Geometry.Point.index(point, bounds, subdivisions)
# => [[1, 524290], [524289, 2]]
```

#### Packing and Encoding

Indexes can then be packed and encoded to improve storage and lookup speed.

An index of `[1,2]` for a 2D space could be packed into 4 bits `<<9::size(4)>>`. This bitstring can then be encoded into a string of (almost equivalent to `Base.url_encode64/2`) URL-safe printable characters `"k"`.

```elixir
index = [1, 2]
packed_index = Spat.pack([1,2], 2) # => <<9::size(4)>>
Spat.encode(packed_index)
# => "k"
```

## Supported Geometries

Currently the only supported geometries are:

* `Spat.Geometry.Point` - n-dimensional points

## Indexing Latitude/Longitude

While you can index any arbitrary coordinate system, this library does not provide any kind of projection, so for non-linear coordinate systems there will be a degree of error (amount of error depends on the coordinate system).

With that said for certain use cases this may work good enough, with or without projecting it to a linear space beforehand.
