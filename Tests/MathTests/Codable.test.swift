//  Copyright (c) 2022 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

@testable import Math
import XCTest

final class CodableTests: XCTestCase {
    var jsonEncode: JSONEncoder!
    var jsonDecode: JSONDecoder!

    override func setUpWithError() throws {
        jsonEncode = JSONEncoder()
        jsonDecode = JSONDecoder()
    }

    func testVector2() throws {
        let vec = Vector2(1, 2)
        let data = try! jsonEncode.encode(vec)
        let newVec = try! jsonDecode.decode(Vector2.self, from: data)
        XCTAssertEqual(vec, newVec)

        // let json = String(data: data, encoding: .utf8)
    }

    func testVector3() {
        let vec = Vector3(1, 2, 3)
        let data = try! jsonEncode.encode(vec)
        let newVec = try! jsonDecode.decode(Vector3.self, from: data)
        XCTAssertEqual(vec, newVec)
    }

    func testVector4() {
        let vec = Vector4(1, 2, 3, 4)
        let data = try! jsonEncode.encode(vec)
        let newVec = try! jsonDecode.decode(Vector4.self, from: data)
        XCTAssertEqual(vec, newVec)
    }

    func testColor() {
        let color = Color(1, 2, 3, 4)
        let data = try! jsonEncode.encode(color)
        let newColor = try! jsonDecode.decode(Color.self, from: data)
        XCTAssertEqual(color, newColor)
    }

    func testQuaternion() {
        let quat = Quaternion(x: 1, y: 2, z: 3, w: 4)
        let data = try! jsonEncode.encode(quat)
        let newQuat = try! jsonDecode.decode(Quaternion.self, from: data)
        XCTAssertEqual(quat, newQuat)
    }

    func testColor32() {
        let color = Color32(r: 1, g: 2, b: 3, a: 4)
        let data = try! jsonEncode.encode(color)
        let newColor = try! jsonDecode.decode(Color32.self, from: data)
        XCTAssertEqual(color, newColor)
    }

    func testMatrix3x3() {
        let mat = Matrix3x3(m11: 1, m12: 2, m13: 3,
                            m21: 4, m22: 5, m23: 6,
                            m31: 7, m32: 8, m33: 9)
        let data = try! jsonEncode.encode(mat)
        let newMat = try! jsonDecode.decode(Matrix3x3.self, from: data)
        XCTAssertEqual(mat, newMat)
    }

    func testMatrix() {
        let mat = Matrix(m11: 1, m12: 2, m13: 3, m14: 4,
                         m21: 5, m22: 6, m23: 7, m24: 8,
                         m31: 9, m32: 10, m33: 11, m34: 12,
                         m41: 13, m42: 14, m43: 15)
        let data = try! jsonEncode.encode(mat)
        let newMat = try! jsonDecode.decode(Matrix.self, from: data)
        XCTAssertEqual(mat, newMat)
    }

    func testBoundingBox() {
        let bounds = Bounds(Vector3(1, 2, 3), Vector3(4, 5, 6))
        let data = try! jsonEncode.encode(bounds)
        let newBounds = try! jsonDecode.decode(Bounds.self, from: data)
        XCTAssertEqual(bounds.min, newBounds.min)
        XCTAssertEqual(bounds.max, newBounds.max)
    }
}
