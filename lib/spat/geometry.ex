defmodule Spat.Geometry do
    @doc """
      Implement the behaviour for calculating the indexes of the requested
      geometry.
    """
    @callback index(geometry :: any, bounds :: Spat.Coord.t, subdivisions :: pos_integer) :: [Spat.subdivision(Spat.grid_index)]
end
