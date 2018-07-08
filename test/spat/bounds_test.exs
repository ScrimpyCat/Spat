defmodule Spat.BoundsTest do
    use ExUnit.Case

    test "bound subdivision" do
        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 1 }), 0)
        assert 0 == Spat.Coord.get(min, 0)
        assert 0.5 == Spat.Coord.get(max, 0)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 1 }), 1)
        assert 0.5 == Spat.Coord.get(min, 0)
        assert 1 == Spat.Coord.get(max, 0)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 1 }, { 2 }), 1)
        assert 1.5 == Spat.Coord.get(min, 0)
        assert 2 == Spat.Coord.get(max, 0)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ -2 }, { -1 }), 0)
        assert -2 == Spat.Coord.get(min, 0)
        assert -1.5 == Spat.Coord.get(max, 0)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ -2 }, { -1 }), 1)
        assert -1.5 == Spat.Coord.get(min, 0)
        assert -1 == Spat.Coord.get(max, 0)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 0)
        assert 0 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 1)
        assert 5 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 2)
        assert 0 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 3)
        assert 5 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 0 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 50 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 4)
        assert 0 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 5)
        assert 5 == Spat.Coord.get(min, 0)
        assert 0 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 25 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 6)
        assert 0 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 5 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)

        %{ min: min, max: max } = Spat.Bounds.subdivide(Spat.Bounds.new({ 10, 50, 100 }), 7)
        assert 5 == Spat.Coord.get(min, 0)
        assert 25 == Spat.Coord.get(min, 1)
        assert 50 == Spat.Coord.get(min, 2)
        assert 10 == Spat.Coord.get(max, 0)
        assert 50 == Spat.Coord.get(max, 1)
        assert 100 == Spat.Coord.get(max, 2)
    end
end
