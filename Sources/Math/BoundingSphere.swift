//  Copyright (c) 2022 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import Foundation

/// A bounding sphere.
public struct BoundingSphere {
    /// The center point of the sphere.
    var _center: Vector3 = .init()

    /// The radius of the sphere.
    var _radius: Float = 0

    public var center: Vector3 {
        _center
    }

    public var radius: Float {
        _radius
    }

    /// Constructor of BoundingSphere.
    /// - Parameters:
    ///   - center: The center point of the sphere
    ///   - radius: The radius of the sphere
    public init(_ center: Vector3? = nil, _ radius: Float = 0) {
        if center != nil {
            _center = center!
        }
        _radius = radius
    }
}

public extension BoundingSphere {
    /// Calculate a bounding sphere that fully contains the given points.
    /// - Parameters:
    ///   - points: The given points
    /// - Returns: The calculated bounding sphere
    static func fromPoints(points: [Vector3]) -> BoundingSphere {
        if points.count == 0 {
            fatalError("points must be array and length must > 0")
        }

        let len = points.count
        var center = Vector3()

        // Calculate the center of the sphere.
        for i in 0 ..< len {
            center = points[i] + center
        }

        // Calculate the radius of the sphere.
        var radius: Float = 0.0
        for i in 0 ..< len {
            let distance = Vector3.distanceSquared(left: center, right: points[i])
            if distance > radius {
                radius = distance
            }
        }

        return BoundingSphere(center / Float(len), sqrt(radius))
    }

    /// Calculate a bounding sphere from a given box.
    /// - Parameters:
    ///   - box: The given box
    /// - Returns: The calculated bounding sphere
    static func fromBox(box: BoundingBox) -> BoundingSphere {
        let min = box.min
        let max = box.max
        let center = Vector3((min.x + max.x) * 0.5, (min.y + max.y) * 0.5, (min.z + max.z) * 0.5)
        return BoundingSphere(center, Vector3.distance(left: center, right: max))
    }
}

extension BoundingSphere: Codable {
    enum CodingKeys: String, CodingKey {
        case center
        case radius
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _center = try container.decode(Vector3.self, forKey: .center)
        _radius = try container.decode(Float.self, forKey: .radius)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_center, forKey: .center)
        try container.encode(_radius, forKey: .radius)
    }
}
