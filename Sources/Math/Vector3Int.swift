//  Copyright (c) 2023 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import simd

/// Representation of 3D vectors and points using integers.
public struct Vector3Int {
    /// An array containing the elements of the vector
    var elements: SIMD3<Int32>

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

    public var z: Int32 {
        get {
            elements.z
        }
        set {
            elements.z = newValue
        }
    }

    /// Shorthand for writing Vector3Int(0, 0, 0).
    public static let zero = Vector3Int(0, 0, 0)
    /// Shorthand for writing Vector3Int(1, 1, 1).
    public static let one = Vector3Int(1, 1, 1)
    /// Shorthand for writing Vector3Int(0, 1, 0).
    public static let up = Vector3Int(0, 1, 0)
    /// Shorthand for writing Vector3Int(0, -1, 0).
    public static let down = Vector3Int(0, -1, 0)
    /// Shorthand for writing Vector3Int(-1, 0, 0).
    public static let left = Vector3Int(-1, 0, 0)
    /// Shorthand for writing Vector3Int(1, 0, 0).
    public static let right = Vector3Int(1, 0, 0)
    /// Shorthand for writing Vector3Int(0, 0, 1).
    public static let forward = Vector3Int(0, 0, 1)
    /// Shorthand for writing Vector3Int(0, 0, -1).
    public static let back = Vector3Int(0, 0, -1)

    /// Initializes and returns an instance of a new Vector3Int with x, y, z components.
    /// - Parameters:
    ///   - x: The X component of the Vector3Int.
    ///   - y: The Y component of the Vector3Int.
    ///   - z: The Z component of the Vector3Int.
    public init(_ x: Int32, _ y: Int32, _ z: Int32 = 0) {
        elements = SIMD3<Int32>(x, y, z)
    }

    /// Set x, y and z components of an existing Vector3Int.
    public mutating func set(_ x: Int32, _ y: Int32, _ z: Int32) {
        elements = SIMD3<Int32>(x, y, z)
    }

    /// Returns the length of this vector (Read Only).
    public var magnitude: Float {
        sqrt(Float(x * x + y * y + z * z))
    }

    /// Returns the squared length of this vector (Read Only).
    public var sqrMagnitude: Int32 {
        x * x + y * y + z * z
    }

    /// Returns the distance between a and b.
    public static func distance(a: Vector3Int, b: Vector3Int) -> Float {
        (a - b).magnitude
    }

    /// Returns a vector that is made from the smallest components of two vectors.
    public static func min(lhs: Vector3Int, rhs: Vector3Int) -> Vector3Int {
        Vector3Int(Swift.min(lhs.x, rhs.x), Swift.min(lhs.y, rhs.y), Swift.min(lhs.z, rhs.z))
    }

    /// Returns a vector that is made from the largest components of two vectors.
    public static func max(lhs: Vector3Int, rhs: Vector3Int) -> Vector3Int {
        Vector3Int(Swift.max(lhs.x, rhs.x), Swift.max(lhs.y, rhs.y), Swift.max(lhs.z, rhs.z))
    }

    /// Multiplies two vectors component-wise.
    public static func scale(a: Vector3Int, b: Vector3Int) -> Vector3Int {
        Vector3Int(a.x * b.x, a.y * b.y, a.z * b.z)
    }

    /// Multiplies every component of this vector by the same component of scale.
    public mutating func scale(_ scale: Vector3Int) {
        x *= scale.x
        y *= scale.y
        z *= scale.z
    }

    /// Clamps the Vector3Int to the bounds given by min and max.
    public mutating func clamp(min: Vector3Int, max: Vector3Int) {
        x = Swift.max(min.x, x)
        x = Swift.min(max.x, x)
        y = Swift.max(min.y, y)
        y = Swift.min(max.y, y)
        z = Swift.max(min.z, z)
        z = Swift.min(max.z, z)
    }

    /// Converts a  Vector3 to a Vector3Int by doing a Floor to each value.
    public static func floorToInt(v: Vector3) -> Vector3Int {
        Vector3Int(Int32(MathUtil.floorToInt(v.x)), Int32(MathUtil.floorToInt(v.y)), Int32(MathUtil.floorToInt(v.z)))
    }

    /// Converts a  Vector3 to a Vector3Int by doing a Ceiling to each value.
    public static func CeilToInt(v: Vector3) -> Vector3Int {
        Vector3Int(Int32(MathUtil.ceilToInt(v.x)), Int32(MathUtil.ceilToInt(v.y)), Int32(MathUtil.ceilToInt(v.z)))
    }

    /// Converts a  Vector3 to a Vector3Int by doing a Round to each value.
    public static func RoundToInt(v: Vector3) -> Vector3Int {
        Vector3Int(Int32(MathUtil.roundToInt(v.x)), Int32(MathUtil.roundToInt(v.y)), Int32(MathUtil.roundToInt(v.z)))
    }

    public static func + (a: Vector3Int, b: Vector3Int) -> Vector3Int {
        Vector3Int(a.x + b.x, a.y + b.y, a.z + b.z)
    }

    public static func - (a: Vector3Int, b: Vector3Int) -> Vector3Int {
        Vector3Int(a.x - b.x, a.y - b.y, a.z - b.z)
    }

    public static func * (a: Vector3Int, b: Vector3Int) -> Vector3Int {
        Vector3Int(a.x * b.x, a.y * b.y, a.z * b.z)
    }

    public static prefix func - (a: Vector3Int) -> Vector3Int {
        Vector3Int(-a.x, -a.y, -a.z)
    }

    public static func * (a: Vector3Int, b: Int32) -> Vector3Int {
        Vector3Int(a.x * b, a.y * b, a.z * b)
    }

    public static func * (a: Int32, b: Vector3Int) -> Vector3Int {
        Vector3Int(a * b.x, a * b.y, a * b.z)
    }

    public static func / (a: Vector3Int, b: Int32) -> Vector3Int {
        Vector3Int(a.x / b, a.y / b, a.z / b)
    }
}

extension Vector3Int: Equatable {}

extension Vector3Int: Codable {}
