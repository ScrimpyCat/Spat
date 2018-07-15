defmodule Spat.Geometry.SphereTest do
    use ExUnit.Case
    doctest Spat.Geometry.Sphere

    test "sphere intersection" do
        assert true == Spat.Geometry.Sphere.intersect({ 0 }, 1, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Sphere.intersect({ 1 }, 1, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Sphere.intersect({ 0.5 }, 1, Spat.Bounds.new({ 1 }))
        assert false == Spat.Geometry.Sphere.intersect({ -1 }, 1, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Sphere.intersect({ -1 }, 2, Spat.Bounds.new({ 1 }))
        assert false == Spat.Geometry.Sphere.intersect({ 1.1 }, 0.1, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Sphere.intersect({ 1.1 }, 1, Spat.Bounds.new({ 1 }))
        assert true == Spat.Geometry.Sphere.intersect({ -1 }, 1, Spat.Bounds.new({ -1 }, { 0 }))
        assert false == Spat.Geometry.Sphere.intersect({ 1 }, 1, Spat.Bounds.new({ -1 }, { 0 }))

        assert false == Spat.Geometry.Sphere.intersect({ 0, 0, 0 }, 1, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert false == Spat.Geometry.Sphere.intersect({ 0, 1, 0 }, 1, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert true == Spat.Geometry.Sphere.intersect({ 0, 1, 2 }, 1, Spat.Bounds.new({ 0, 1, 2 }, { 1, 2, 3 }))
        assert true == Spat.Geometry.Sphere.intersect({ 10, 10, 10 }, 1, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
        assert false == Spat.Geometry.Sphere.intersect({ 10, 10, 10.1 }, 0.05, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
        assert true == Spat.Geometry.Sphere.intersect({ 15, 15, 15 }, 10, Spat.Bounds.new({ 0, 1, 2 }, { 10, 10, 10 }))
    end
end
