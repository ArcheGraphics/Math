//  Copyright (c) 2022 Feng Yang
//
//  I am making my contributions/submissions to this project solely in my
//  personal capacity and am not conveying any rights to any intellectual
//  property of any third parties.

import XCTest
@testable import Math

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
    
    func testBoundingBox() {
        let bounds = Bounds(Vector3(1, 2, 3), Vector3(4, 5, 6))
        let data = try! jsonEncode.encode(bounds)
        let newBounds = try! jsonDecode.decode(Bounds.self, from: data)
        XCTAssertEqual(bounds.min, newBounds.min)
        XCTAssertEqual(bounds.max, newBounds.max)
    }
}
