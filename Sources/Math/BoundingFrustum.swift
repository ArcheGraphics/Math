//  Copyright (c) 2022 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import Foundation

/// A bounding frustum.
public struct BoundingFrustum {
    /// The near plane of this frustum.
    var _near: Plane
    /// The far plane of this frustum.
    var _far: Plane
    /// The left plane of this frustum.
    var _left: Plane
    /// The right plane of this frustum.
    var _right: Plane
    /// The top plane of this frustum.
    var _top: Plane
    /// The bottom plane of this frustum.
    var _bottom: Plane

    public var near: Plane {
        _near
    }

    public var far: Plane {
        _far
    }

    public var left: Plane {
        _left
    }

    public var right: Plane {
        _right
    }

    public var top: Plane {
        _top
    }

    public var bottom: Plane {
        _bottom
    }

    /// Constructor of BoundingFrustum.
    /// - Parameter matrix: The view-projection matrix
    public init(matrix: Matrix? = nil) {
        _near = Plane()
        _far = Plane()
        _left = Plane()
        _right = Plane()
        _top = Plane()
        _bottom = Plane()

        if matrix != nil {
            calculateFromMatrix(matrix: matrix!)
        }
    }
}

public extension BoundingFrustum {
    func getPlane(index: Int) -> Plane {
        getPlane(face: FrustumFace(rawValue: index) ?? FrustumFace.Top)
    }

    /// Get the plane by the given face.
    /// - Parameter face - The frustum face
    /// - Returns: The plane get
    func getPlane(face: FrustumFace) -> Plane {
        switch face {
        case FrustumFace.Near:
            return near
        case FrustumFace.Far:
            return far
        case FrustumFace.Left:
            return left
        case FrustumFace.Right:
            return right
        case FrustumFace.Bottom:
            return bottom
        case FrustumFace.Top:
            return top
        }
    }

    /// Update all planes from the given matrix.
    /// - Parameter matrix: The given view-projection matrix
    mutating func calculateFromMatrix(matrix: Matrix) {
        let m11 = matrix.elements.columns.0[0]
        let m12 = matrix.elements.columns.0[1]
        let m13 = matrix.elements.columns.0[2]
        let m14 = matrix.elements.columns.0[3]

        let m21 = matrix.elements.columns.1[0]
        let m22 = matrix.elements.columns.1[1]
        let m23 = matrix.elements.columns.1[2]
        let m24 = matrix.elements.columns.1[3]

        let m31 = matrix.elements.columns.2[0]
        let m32 = matrix.elements.columns.2[1]
        let m33 = matrix.elements.columns.2[2]
        let m34 = matrix.elements.columns.2[3]

        let m41 = matrix.elements.columns.3[0]
        let m42 = matrix.elements.columns.3[1]
        let m43 = matrix.elements.columns.3[2]
        let m44 = matrix.elements.columns.3[3]

        // near
        _near = Plane(Vector3(m14 + m13, m24 + m23, m34 + m33), m44 + m43)
        _near = _near.normalized

        // far
        _far = Plane(Vector3(m14 - m13, m24 - m23, m34 - m33), m44 - m43)
        _far = _far.normalized

        // left
        _left = Plane(Vector3(m14 + m11, m24 + m21, m34 + m31), m44 + m41)
        _left = _left.normalized

        // right
        _right = Plane(Vector3(m14 - m11, m24 - m21, m34 - m31), m44 - m41)
        _right = _right.normalized

        // bottom
        _bottom = Plane(Vector3(m14 + m12, m24 + m22, m34 + m32), m44 + m42)
        _bottom = _bottom.normalized

        // top
        _top = Plane(Vector3(m14 - m12, m24 - m22, m34 - m32), m44 - m42)
        _top = _top.normalized
    }

    /// Get whether or not a specified bounding box intersects with this frustum (Contains or Intersects).
    /// - Parameter box: The box for testing
    /// - Returns: True if bounding box intersects with this frustum, false otherwise
    func intersectsBox(box: BoundingBox) -> Bool {
        CollisionUtil.intersectsFrustumAndBox(frustum: self, box: box)
    }

    /// Get whether or not a specified bounding sphere intersects with this frustum (Contains or Intersects).
    /// - Parameter sphere: The sphere for testing
    /// - Returns: True if bounding sphere intersects with this frustum, false otherwise
    func intersectsSphere(sphere: BoundingSphere) -> Bool {
        CollisionUtil.frustumContainsSphere(frustum: self, sphere: sphere) != ContainmentType.Disjoint
    }
}

extension BoundingFrustum: Codable {
    enum CodingKeys: String, CodingKey {
        case near
        case far
        case left
        case right
        case top
        case bottom
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _near = try container.decode(Plane.self, forKey: .near)
        _far = try container.decode(Plane.self, forKey: .far)
        _left = try container.decode(Plane.self, forKey: .left)
        _right = try container.decode(Plane.self, forKey: .right)
        _top = try container.decode(Plane.self, forKey: .top)
        _bottom = try container.decode(Plane.self, forKey: .bottom)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_near, forKey: .near)
        try container.encode(_far, forKey: .far)
        try container.encode(_left, forKey: .left)
        try container.encode(_right, forKey: .right)
        try container.encode(_top, forKey: .top)
        try container.encode(_bottom, forKey: .bottom)
    }
}
