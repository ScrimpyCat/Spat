defmodule Spat.GeometryTest do
    use ExUnit.Case

    test "bound subdivision" do
        { min, max } = Spat.Geometry.subdivide({ 0 }, { 1 }, 1, 0)
        assert 0 == Spat.Coord.get(min, 0)
        assert 0.5 == Spat.Coord.get(max, 0)

        { min, max } = Spat.Geometry.subdivide({ 0 }, { 1 }, 1, 1)
        assert 0.5 == Spat.Coord.get(min, 0)
        assert 1 == Spat.Coord.get(max, 0)

        { min, max } = Spat.Geometry.subdivide({ 1 }, { 2 }, 1, 1)
        assert 1.5 == Spat.Coord.get(min, 0)
        assert 2 == Spat.Coord.get(max, 0)

        { min, max } = Spat.Geometry.subdivide({ -2 }, { -1 }, 1, 0)
        assert -2 == Spat.Coord.get(min, 0)
        assert -1.5 == Spat.Coord.get(max, 0)

        { min, max } = Spat.Geometry.subdivide({ -2 }, { -1 }, 1, 1)
        assert -1.5 == Spat.Coord.get(min, 0)
        assert -1 == Spat.Coord.get(max, 0)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 0)
        assert 0 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 1)
        assert 5 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 2)
        assert 0 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 3)
        assert 5 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 4)
        assert 0 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 5)
        assert 5 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 6)
        assert 0 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)

        { min, max } = Spat.Geometry.subdivide({ 0, 0, 0 }, { 10, 50, 100 }, 3, 7)
        assert 5 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)
    end
end
