//  Copyright (c) 2022 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import simd

/// Represents a four dimensional mathematical quaternion.
public struct Quaternion {
    var elements: simd_quatf

    public var x: Float {
        get {
            elements.imag.x
        }
        set {
            elements.imag.x = newValue
        }
    }

    public var y: Float {
        get {
            elements.imag.y
        }
        set {
            elements.imag.y = newValue
        }
    }

    public var z: Float {
        get {
            elements.imag.z
        }
        set {
            elements.imag.z = newValue
        }
    }

    public var w: Float {
        get {
            elements.real
        }
        set {
            elements.real = newValue
        }
    }

    public var axis: Vector3 {
        Vector3(elements.axis)
    }

    public var angle: Float {
        elements.angle
    }

    public var internalValue: simd_quatf {
        elements
    }

    public var conjugate: Quaternion {
        Quaternion(elements.conjugate)
    }

    /// Calculate the inverse of the specified quaternion.
    public var invert: Quaternion {
        Quaternion(elements.inverse)
    }

    /// Converts the vector into a unit vector.
    /// - Parameters:
    ///   - left: The vector to normalize
    /// - Returns: The normalized vector
    public var normalized: Quaternion {
        Quaternion(elements.normalized)
    }

    public init() {
        elements = simd_quatf(ix: 0, iy: 0, iz: 0, r: 1)
    }

    /// Constructor of Quaternion.
    /// - Parameters:
    ///   - x: The x component of the quaternion, default 0
    ///   - y: The y component of the quaternion, default 0
    ///   - z: The z component of the quaternion, default 0
    ///   - w: The w component of the quaternion, default 1
    public init(x: Float = 0, y: Float = 0, z: Float = 0, w: Float = 1) {
        elements = simd_quatf(ix: x, iy: y, iz: z, r: w)
    }

    public init(_ m: Matrix3x3) {
        elements = simd_quatf(m.elements)
    }

    public init(_ m: Matrix) {
        elements = simd_quatf(m.elements)
    }

    /// Calculate a quaternion rotates around an arbitrary axis.
    /// - Parameters:
    ///   - axis: The axis
    ///   - rad: The rotation angle in radians
    /// - Returns: The quaternion after rotate
    public init(axis: Vector3, rad: Float) {
        elements = simd_quatf(angle: rad, axis: axis.normalized.elements)
    }

    public init(from: Vector3, to: Vector3) {
        elements = simd_quatf(from: from.elements, to: to.elements)
    }

    /// Constructor of Quaternion.
    /// - Parameters:
    ///   - array: The component of the vector
    public init(_ array: simd_quatf) {
        elements = array
    }
}

// MARK: - Static Methods

public extension Quaternion {
    /// Determines the sum of two vectors.
    /// - Parameters:
    ///   - left: The first vector to add
    ///   - right: The second vector to add
    /// - Returns: The sum of two vectors
    static func + (left: Quaternion, right: Quaternion) -> Quaternion {
        Quaternion(left.elements + right.elements)
    }

    static func += (left: inout Quaternion, right: Quaternion) {
        left.elements += right.elements
    }

    static func - (left: Quaternion, right: Quaternion) -> Quaternion {
        Quaternion(left.elements - right.elements)
    }

    static func -= (left: inout Quaternion, right: Quaternion) {
        left.elements -= right.elements
    }

    static prefix func - (rhs: Quaternion) -> Quaternion {
        Quaternion(-rhs.elements)
    }

    /// Determines the product of two vectors.
    /// - Parameters:
    ///   - left: The first vector to multiply
    ///   - right: The second vector to multiply
    /// - Returns: The product of two vectors
    static func * (left: Quaternion, right: Quaternion) -> Quaternion {
        Quaternion(left.elements * right.elements)
    }

    static func *= (left: inout Quaternion, right: Quaternion) {
        left.elements *= right.elements
    }

    /// Scale a vector by the given value.
    /// - Parameters:
    ///   - left: The vector to scale
    ///   - s: The amount by which to scale the vector
    /// - Returns: The scaled vector
    static func * (left: Quaternion, s: Float) -> Quaternion {
        Quaternion(left.elements * s)
    }

    static func * (left: Float, s: Quaternion) -> Quaternion {
        Quaternion(left * s.elements)
    }

    static func *= (left: inout Quaternion, right: Float) {
        left.elements *= right
    }

    static func / (left: Quaternion, s: Float) -> Quaternion {
        Quaternion(left.elements / s)
    }

    static func /= (left: inout Quaternion, right: Float) {
        left.elements /= right
    }
}

public extension Quaternion {
    /// Determines the dot product of two vectors.
    /// - Parameters:
    ///   - left: The first vector to dot
    ///   - right: The second vector to dot
    /// - Returns: The dot product of two vectors
    static func dot(left: Quaternion, right: Quaternion) -> Float {
        simd_dot(left.elements, right.elements)
    }

    /// Determines whether the specified vectors are equals.
    /// - Parameters:
    ///   - left: The first vector to compare
    ///   - right: The second vector to compare
    /// - Returns: True if the specified vectors are equals, false otherwise
    static func equals(left: Quaternion, right: Quaternion) -> Bool {
        MathUtil.equals(left.x, right.x) &&
            MathUtil.equals(left.y, right.y) &&
            MathUtil.equals(left.z, right.z) &&
            MathUtil.equals(left.w, right.w)
    }

    /// Calculate a quaternion from the specified yaw, pitch and roll angles.
    /// - Parameters:
    ///   - yaw: Yaw around the y axis in radians
    ///   - pitch: Pitch around the x axis in radians
    ///   - roll: Roll around the z axis in radians
    /// - Returns: The calculated quaternion
    static func rotationYawPitchRoll(yaw: Float, pitch: Float, roll: Float) -> Quaternion {
        let halfRoll = roll * 0.5
        let halfPitch = pitch * 0.5
        let halfYaw = yaw * 0.5

        let sinRoll = sin(halfRoll)
        let cosRoll = cos(halfRoll)
        let sinPitch = sin(halfPitch)
        let cosPitch = cos(halfPitch)
        let sinYaw = sin(halfYaw)
        let cosYaw = cos(halfYaw)

        let cosYawPitch = cosYaw * cosPitch
        let sinYawPitch = sinYaw * sinPitch

        return Quaternion(x: cosYaw * sinPitch * cosRoll + sinYaw * cosPitch * sinRoll,
                          y: sinYaw * cosPitch * cosRoll - cosYaw * sinPitch * sinRoll,
                          z: cosYawPitch * sinRoll - sinYawPitch * cosRoll,
                          w: cosYawPitch * cosRoll + sinYawPitch * sinRoll)
    }

    /// Calculate a quaternion rotates around x, y, z axis (pitch/yaw/roll).
    /// - Parameters:
    ///   - x: The radian of rotation around X (pitch)
    ///   - y: The radian of rotation around Y (yaw)
    ///   - z: The radian of rotation around Z (roll)
    /// - Returns: The calculated quaternion
    static func rotationEuler(x: Float, y: Float, z: Float) -> Quaternion {
        Quaternion.rotationYawPitchRoll(yaw: y, pitch: x, roll: z)
    }

    static func euler(_ e: Vector3) -> Quaternion {
        Quaternion.rotationYawPitchRoll(yaw: e.y, pitch: e.x, roll: e.z)
    }

    /// Performs a spherical linear blend between two quaternions.
    /// - Parameters:
    ///   - start: The first quaternion
    ///   - end: The second quaternion
    ///   - t: The blend amount where 0 returns start and 1 end
    /// - Returns: The result of spherical linear blending between two quaternions
    static func slerp(start: Quaternion, end: Quaternion, t: Float) -> Quaternion {
        Quaternion(simd_slerp(start.elements, end.elements, t))
    }

    /// Calculate a quaternion rotate around X axis.
    /// - Parameters:
    ///   - rad: The rotation angle in radians
    /// - Returns: The calculated quaternion
    static func rotationX(rad: Float) -> Quaternion {
        let rad = rad * 0.5
        let s = sin(rad)
        let c = cos(rad)

        return Quaternion(x: s, y: 0, z: 0, w: c)
    }

    /// Calculate a quaternion rotate around Y axis.
    /// - Parameters:
    ///   - rad: The rotation angle in radians
    /// - Returns: The calculated quaternion
    static func rotationY(rad: Float) -> Quaternion {
        let rad = rad * 0.5
        let s = sin(rad)
        let c = cos(rad)

        return Quaternion(x: 0, y: s, z: 0, w: c)
    }

    /// Calculate a quaternion rotate around Z axis.
    /// - Parameters:
    ///   - rad: The rotation angle in radians
    /// - Returns: The calculated quaternion
    static func rotationZ(rad: Float) -> Quaternion {
        let rad = rad * 0.5
        let s = sin(rad)
        let c = cos(rad)

        return Quaternion(x: 0, y: 0, z: s, w: c)
    }

    /// Calculate a quaternion that the specified quaternion rotate around X axis.
    /// - Parameters:
    ///   - quaternion: The specified quaternion
    ///   - rad: The rotation angle in radians
    /// - Returns: The calculated quaternion
    static func rotateX(quaternion: Quaternion, rad: Float) -> Quaternion {
        let x = quaternion.x
        let y = quaternion.y
        let z = quaternion.z
        let w = quaternion.w
        let rad = rad * 0.5
        let bx = sin(rad)
        let bw = cos(rad)

        return Quaternion(x: x * bw + w * bx,
                          y: y * bw + z * bx,
                          z: z * bw - y * bx,
                          w: w * bw - x * bx)
    }

    /// Calculate a quaternion that the specified quaternion rotate around Y axis.
    /// - Parameters:
    ///   - quaternion: The specified quaternion
    ///   - rad: The rotation angle in radians
    /// - Returns: The calculated quaternion
    static func rotateY(quaternion: Quaternion, rad: Float) -> Quaternion {
        let x = quaternion.x
        let y = quaternion.y
        let z = quaternion.z
        let w = quaternion.w
        let rad = rad * 0.5
        let by = sin(rad)
        let bw = cos(rad)

        return Quaternion(x: x * bw - z * by,
                          y: y * bw + w * by,
                          z: z * bw + x * by,
                          w: w * bw - y * by)
    }

    /// Calculate a quaternion that the specified quaternion rotate around Z axis.
    /// - Parameters:
    ///   - quaternion: The specified quaternion
    ///   - rad: The rotation angle in radians
    /// - Returns: The calculated quaternion
    static func rotateZ(quaternion: Quaternion, rad: Float) -> Quaternion {
        let x = quaternion.x
        let y = quaternion.y
        let z = quaternion.z
        let w = quaternion.w
        let rad = rad * 0.5
        let bz = sin(rad)
        let bw = cos(rad)

        return Quaternion(x: x * bw + y * bz,
                          y: y * bw - x * bz,
                          z: z * bw + w * bz,
                          w: w * bw - z * bz)
    }

    /// Returns the angle in degrees between two rotations a and b.
    static func angle(_ a: Quaternion, _ b: Quaternion) -> Float {
        let num = min(abs(Quaternion.dot(left: a, right: b)), 1)
        return Quaternion.isEqualUsingDot(num) ? 0.0 : (acos(num) * 2.0 * 57.295780181884766)
    }

    private static func isEqualUsingDot(_ dot: Float) -> Bool {
        dot > 0.9999989867210388
    }
}

public extension Quaternion {
    /// Set the value of this vector.
    /// - Parameters:
    ///   - x: The x component of the vector
    ///   - y: The y component of the vector
    ///   - z: The z component of the vector
    ///   - w: The w component of the vector
    /// - Returns: This vector
    internal mutating func set(x: Float, y: Float, z: Float, w: Float) -> Quaternion {
        elements = simd_quatf(ix: x, iy: y, iz: z, r: w)
        return self
    }

    /// Set the value of this vector by an array.
    /// - Parameters:
    ///   - array: The array
    ///   - offset: The start offset of the array
    /// - Returns: This vector
    internal mutating func set(array: [Float], offset: Int = 0) -> Quaternion {
        elements = simd_quatf(ix: array[offset],
                              iy: array[offset + 1],
                              iz: array[offset + 2],
                              r: array[offset + 2])
        return self
    }

    /// Calculate this quaternion rotate around X axis.
    /// - Parameter rad: The rotation angle in radians
    /// - Returns: This quaternion
    mutating func rotateX(rad: Float) -> Quaternion {
        self = Quaternion.rotateX(quaternion: self, rad: rad)
        return self
    }

    /// Calculate this quaternion rotate around Y axis.
    /// - Parameter rad: The rotation angle in radians
    /// - Returns: This quaternion
    mutating func rotateY(rad: Float) -> Quaternion {
        self = Quaternion.rotateY(quaternion: self, rad: rad)
        return self
    }

    /// Calculate this quaternion rotate around Z axis.
    /// - Parameter rad: The rotation angle in radians
    /// - Returns: This quaternion
    mutating func rotateZ(rad: Float) -> Quaternion {
        self = Quaternion.rotateZ(quaternion: self, rad: rad)
        return self
    }

    /// Performs a linear blend between this quaternion and the specified quaternion.
    /// - Parameters:
    ///   - quat: The specified quaternion
    ///   - t: The blend amount where 0 returns this and 1 quat
    /// - Returns: The result of linear blending between two quaternions
    mutating func lerp(quat: Quaternion, t: Float) -> Quaternion {
        self = Quaternion.slerp(start: self, end: quat, t: t)
        return self
    }
}

public extension Quaternion {
    /// Determines the dot product of this quaternion and the specified quaternion.
    /// - Parameter quat: The specified quaternion
    /// - Returns: The dot product of two quaternions
    func dot(quat: Quaternion) -> Float {
        Quaternion.dot(left: self, right: quat)
    }

    /// Calculate the length of this quaternion.
    /// - Returns: The length of this quaternion
    func length() -> Float {
        elements.length
    }

    /// Calculates the squared length of this quaternion.
    /// - Returns: The squared length of this quaternion
    func lengthSquared() -> Float {
        x * x + y * y + z * z + w * w
    }

    /// Get the euler of this quaternion.
    /// - Returns: Euler x->pitch y->yaw z->roll
    func toEuler() -> Vector3 {
        let out = toYawPitchRoll()
        return Vector3(out.y, out.x, out.z)
    }

    /// Get the euler of this quaternion.
    /// - Returns: Euler x->yaw y->pitch z->roll
    func toYawPitchRoll() -> Vector3 {
        let xx = x * x
        let yy = y * y
        let zz = z * z
        let xy = x * y
        let zw = z * w
        let zx = z * x
        let yw = y * w
        let yz = y * z
        let xw = x * w

        let y = asin(2.0 * (xw - yz))
        var x: Float = 0
        var z: Float = 0
        if cos(y) > Float.leastNonzeroMagnitude {
            z = atan2(2.0 * (xy + zw), 1.0 - 2.0 * (zz + xx))
            x = atan2(2.0 * (zx + yw), 1.0 - 2.0 * (yy + xx))
        } else {
            z = atan2(-2.0 * (xy - zw), 1.0 - 2.0 * (yy + zz))
            x = 0.0
        }

        return Vector3(x, y, z)
    }

    /// Clone the value of this quaternion to an array.
    /// - Parameters:
    ///   - out: The array
    ///   - outOffset: The start offset of the array
    func toArray(out: inout [Float], outOffset: Int = 0) {
        out[outOffset] = x
        out[outOffset + 1] = y
        out[outOffset + 2] = z
        out[outOffset + 3] = w
    }
}

extension Quaternion: Codable {
    enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
        case w
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(z, forKey: .z)
        try container.encode(w, forKey: .w)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(Float.self, forKey: .x)
        let y = try container.decode(Float.self, forKey: .y)
        let z = try container.decode(Float.self, forKey: .z)
        let w = try container.decode(Float.self, forKey: .w)
        elements = simd_quatf(ix: x, iy: y, iz: z, r: w)
    }
}

extension Quaternion: Equatable {
    public static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
        Quaternion.equals(left: lhs, right: rhs)
    }
}
