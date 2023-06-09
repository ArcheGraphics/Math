//  Copyright (c) 2022 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import simd

/// Represents a plane in three dimensional space.
public struct Plane {
    /// The normal of the plane.
    var _normal: Vector3 = .init()
    /// The distance of the plane along its normal to the origin.
    var _distance: Float = 0

    public var normal: Vector3 {
        _normal
    }

    public var distance: Float {
        _distance
    }

    /// Normalize the normal vector of the specified plane.
    /// - Parameters:
    ///   - p: The specified plane
    /// - Returns: A normalized version of the specified plane
    public var normalized: Plane {
        let factor = 1.0 / _normal.length()
        return Plane(_normal * factor, _distance * factor)
    }

    /// Creates a plane.
    public init(_ inNormal: Vector3, _ inPoint: Vector3) {
        _normal = inNormal.normalized
        _distance = -Vector3.dot(left: _normal, right: inPoint)
    }

    /// Constructor of Plane.
    /// - Parameters:
    ///   - normal: The normal vector
    ///   - distance: The distance of the plane along its normal to the origin
    public init(_ normal: Vector3? = nil, _ distance: Float = 0) {
        if normal != nil {
            _normal = normal!
        }
        _distance = distance
    }

    /// Sets a plane using a point that lies within it along with a normal to orient it.
    /// - Parameters:
    ///   - inNormal: The plane's normal vector.
    ///   - inPoint: A point that lies on the plane.
    public mutating func setNormalAndPosition(_ inNormal: Vector3, _ inPoint: Vector3) {
        _normal = inNormal.normalized
        _distance = -Vector3.dot(left: inNormal, right: inPoint)
    }
}

public extension Plane {
    /// Calculate the plane that contains the three specified points.
    /// - Parameters:
    ///   - point0: The first point
    ///   - point1: The second point
    ///   - point2: The third point
    /// - Returns: The calculated plane
    static func fromPoints(point0: Vector3, point1: Vector3, point2: Vector3) -> Plane {
        let x0 = point0.x
        let y0 = point0.y
        let z0 = point0.z
        let x1 = point1.x - x0
        let y1 = point1.y - y0
        let z1 = point1.z - z0
        let x2 = point2.x - x0
        let y2 = point2.y - y0
        let z2 = point2.z - z0
        let yz = y1 * z2 - z1 * y2
        let xz = z1 * x2 - x1 * z2
        let xy = x1 * y2 - y1 * x2
        let invPyth = 1.0 / sqrt(yz * yz + xz * xz + xy * xy)

        let x = yz * invPyth
        let y = xz * invPyth
        let z = xy * invPyth

        return Plane(Vector3(x, y, z), -(x * x0 + y * y0 + z * z0))
    }
}

extension Plane: Codable {
    enum CodingKeys: String, CodingKey {
        case normal
        case distance
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _normal = try container.decode(Vector3.self, forKey: .normal)
        _distance = try container.decode(Float.self, forKey: .distance)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(normal, forKey: .normal)
        try container.encode(distance, forKey: .distance)
    }
}
