# Spat

Spat is a spatial hashing library. That is used for hashing geometries in linear regions for n-dimensions.

### How it works

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

When some calculating the index for a given geometry, it looks up where it is located in the subdivided region and the resulting location(s) is its index.

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
point = {60, 48}
subdivisions = 2
Spat.Geometry.Point.index(point, bounds, subdivisions)
# => [[1, 2]]
```

While in 3D space it would be adapted as follows:

```bob
                              +-------------+-------------+
                             /             /              |
                            /      6      /      7      / |
                           +-------------+-------------   |
                          /             /              |  |
                         /      2      /      3      / |7 |
   +- -- -- -- --       + -- -- -- -- + -- -- -- --    |  +
                 |      |             |             |  | /|
 /      4      /        |             |              3 |/ |
  -- -- -- --    |      |      2      |      3      |  +  |
|             |         |             |               /|  |
               4 |      |             |             |/ |5 |
|      4      |         +-------------+-------------+  |  +
                /   --> |             |             |  | /
|             |         |             |              1 |/
  -- -- -- --           |      0      |      1      |  +
                        |             |               /
                        |             |             |/
                        +-------------+-------------+
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
