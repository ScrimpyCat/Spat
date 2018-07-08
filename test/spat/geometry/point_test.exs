defmodule Spat.Geometry.PointTest do
    use ExUnit.Case
    doctest Spat.Geometry.Point

    test "point intersection" do
        assert true == Spat.Geometry.Point.intersect({ 0 }, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Point.intersect({ 1 }, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Point.intersect({ 0.5 }, Spat.Bounds.new({ 1 }))
        assert false == Spat.Geometry.Point.intersect({ -1 }, Spat.Bounds.new({ 1 }))
        assert false == Spat.Geometry.Point.intersect({ 1.1 }, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Point.intersect({ -1 }, Spat.Bounds.new({ -1 }, { 0 }))
        assert false == Spat.Geometry.Point.intersect({ 1 }, Spat.Bounds.new({ -1 }, { 0 }))

        assert false == Spat.Geometry.Point.intersect({ 0, 0, 0 }, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert false == Spat.Geometry.Point.intersect({ 0, 1, 0 }, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert true == Spat.Geometry.Point.intersect({ 0, 1, 2 }, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert true == Spat.Geometry.Point.intersect({ 10, 10, 10 }, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
        assert false == Spat.Geometry.Point.intersect({ 10, 10, 10.1 }, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
    end
end
