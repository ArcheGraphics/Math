//  Copyright (c) 2023 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import simd

/// Representation of 2D vectors and points using integers.
public struct Vector2Int {
    /// An array containing the elements of the vector
    var elements: SIMD2<Int32>

    public var x: Int32 {
        get {
            elements.x
        }
        set {
            elements.x = newValue
        }
    }

    public var y: Int32 {
        get {
            elements.y
        }
        set {
            elements.y = newValue
        }
    }

    /// Shorthand for writing Vector2Int(0, 0).
    public static let zero = Vector2Int(0, 0)
    /// Shorthand for writing Vector2Int(1, 1).
    public static let one = Vector2Int(1, 1)
    /// Shorthand for writing Vector2Int(0, 1).
    public static let up = Vector2Int(0, 1)
    /// Shorthand for writing Vector2Int(0, -1).
    public static let down = Vector2Int(0, -1)
    /// Shorthand for writing Vector2Int(-1, 0).
    public static let left = Vector2Int(-1, 0)
    /// Shorthand for writing Vector2Int(1, 0).
    public static let right = Vector2Int(1, 0)

    public init(_ x: Int32, _ y: Int32) {
        elements = SIMD2<Int32>(x, y)
    }

    /// Set x and y components of an existing Vector2Int.
    public mutating func set(_ x: Int32, _ y: Int32) {
        elements = SIMD2<Int32>(x, y)
    }

    /// Returns the length of this vector (Read Only).
    public var magnitude: Float {
        sqrt(Float(x * x + y * y))
    }

    /// Returns the squared length of this vector (Read Only).
    public var sqrMagnitude: Int32 {
        x * x + y * y
    }

    /// Returns the distance between a and b.
    public static func distance(a: Vector2Int, b: Vector2Int) -> Float {
        let num1 = Float(a.x - b.x)
        let num2 = Float(a.y - b.y)
        return Float(sqrt(Double(num1) * Double(num1) + Double(num2) * Double(num2)))
    }

    /// Returns a vector that is made from the smallest components of two vectors.
    public static func min(lhs: Vector2Int, rhs: Vector2Int) -> Vector2Int {
        Vector2Int(Swift.min(lhs.x, rhs.x), Swift.min(lhs.y, rhs.y))
    }

    /// Returns a vector that is made from the largest components of two vectors.
    public static func max(lhs: Vector2Int, rhs: Vector2Int) -> Vector2Int {
        Vector2Int(Swift.max(lhs.x, rhs.x), Swift.max(lhs.y, rhs.y))
    }

    /// Multiplies two vectors component-wise.
    public static func scale(a: Vector2Int, b: Vector2Int) -> Vector2Int {
        Vector2Int(a.x * b.x, a.y * b.y)
    }

    /// Multiplies every component of this vector by the same component of scale.
    public mutating func scale(_ scale: Vector2Int) {
        x *= scale.x
        y *= scale.y
    }

    /// Clamps the Vector2Int to the bounds given by min and max.
    public mutating func clamp(min: Vector2Int, max: Vector2Int) {
        x = Swift.max(min.x, x)
        x = Swift.min(max.x, x)
        y = Swift.max(min.y, y)
        y = Swift.min(max.y, y)
    }

    /// Converts a Vector2 to a Vector2Int by doing a Floor to each value.
    public static func floorToInt(v: Vector2) -> Vector2Int {
        Vector2Int(Int32(MathUtil.floorToInt(v.x)), Int32(MathUtil.floorToInt(v.y)))
    }

    /// Converts a  Vector2 to a Vector2Int by doing a Ceiling to each value.
    public static func ceilToInt(v: Vector2) -> Vector2Int {
        Vector2Int(Int32(MathUtil.ceilToInt(v.x)), Int32(MathUtil.ceilToInt(v.y)))
    }

    /// Converts a  Vector2 to a Vector2Int by doing a Round to each value.
    public static func roundToInt(v: Vector2) -> Vector2Int {
        Vector2Int(Int32(MathUtil.roundToInt(v.x)), Int32(MathUtil.roundToInt(v.y)))
    }

    public static prefix func - (v: Vector2Int) -> Vector2Int {
        Vector2Int(-v.x, -v.y)
    }

    public static func + (a: Vector2Int, b: Vector2Int) -> Vector2Int {
        Vector2Int(a.x + b.x, a.y + b.y)
    }

    public static func - (a: Vector2Int, b: Vector2Int) -> Vector2Int {
        Vector2Int(a.x - b.x, a.y - b.y)
    }

    public static func * (a: Vector2Int, b: Vector2Int) -> Vector2Int {
        Vector2Int(a.x * b.x, a.y * b.y)
    }

    public static func * (a: Int32, b: Vector2Int) -> Vector2Int {
        Vector2Int(a * b.x, a * b.y)
    }

    public static func * (a: Vector2Int, b: Int32) -> Vector2Int {
        Vector2Int(a.x * b, a.y * b)
    }

    public static func / (a: Vector2Int, b: Int32) -> Vector2Int {
        Vector2Int(a.x / b, a.y / b)
    }
}
