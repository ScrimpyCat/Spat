defmodule Spat.Geometry.BoxTest do
    use ExUnit.Case
    doctest Spat.Geometry.Box

    test "box intersection" do
        assert true == Spat.Geometry.Box.intersect({ 0 }, { 1 }, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Box.intersect({ 1 }, { 2 }, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Box.intersect({ 0.5 }, { 1 }, Spat.Bounds.new({ 1 }))
        assert false == Spat.Geometry.Box.intersect({ -1 }, { -0.5 }, Spat.Bounds.new({ 1 }))
        assert false == Spat.Geometry.Box.intersect({ 1.1 }, { 2 }, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Box.intersect({ -1 }, { -0.5 }, Spat.Bounds.new({ -1 }, { 0 }))
        assert false == Spat.Geometry.Box.intersect({ 1 }, { 2 }, Spat.Bounds.new({ -1 }, { 0 }))

        assert false == Spat.Geometry.Box.intersect({ 0, 0, 0 }, { 1, 1, 1 }, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert false == Spat.Geometry.Box.intersect({ 0, 1, 0 }, { 1, 2, 1 }, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert true == Spat.Geometry.Box.intersect({ 0, 1, 2 }, { 1, 2, 3 }, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert true == Spat.Geometry.Box.intersect({ 10, 10, 10 }, { 11, 11, 11 }, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
        assert false == Spat.Geometry.Box.intersect({ 10, 10, 10.1 }, { 11, 11, 11 }, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
    end
end
