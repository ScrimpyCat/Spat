defmodule Spat.Geometry do
    @doc """
      Implement the behaviour for calculating the indexes of the requested
      geometry.
    """
    @callback index(geometry :: any, bounds :: { min :: Spat.Coord.t, max :: Spat.Coord.t }, subdivisions :: pos_integer) :: [Spat.grid_index]
end
