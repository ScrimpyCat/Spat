defmodule Spat.Geometry.PointTest do
    use ExUnit.Case
    doctest Spat.Geometry.Point

    test "point intersection" do
        assert true == Spat.Geometry.Point.intersect({ 0 }, { 0 }, { 1 }, 1)
        assert true == Spat.Geometry.Point.intersect({ 1 }, { 0 }, { 1 }, 1)
        assert true == Spat.Geometry.Point.intersect({ 0.5 }, { 0 }, { 1 }, 1)
        assert false == Spat.Geometry.Point.intersect({ -1 }, { 0 }, { 1 }, 1)
        assert false == Spat.Geometry.Point.intersect({ 1.1 }, { 0 }, { 1 }, 1)

        assert false == Spat.Geometry.Point.intersect({ 0, 0, 0 }, { 0, 1, 2 }, { 1, 2, 3 }, 3)
        assert false == Spat.Geometry.Point.intersect({ 0, 1, 0 }, { 0, 1, 2 }, { 1, 2, 3 }, 3)
        assert true == Spat.Geometry.Point.intersect({ 0, 1, 2 }, { 0, 1, 2 }, { 1, 2, 3 }, 3)
        assert true == Spat.Geometry.Point.intersect({ 10, 10, 10 }, { 0, 1, 2 }, { 10, 10, 10 }, 3)
        assert false == Spat.Geometry.Point.intersect({ 10, 10, 10.1 }, { 0, 1, 2 }, { 10, 10, 10 }, 3)
    end
end
