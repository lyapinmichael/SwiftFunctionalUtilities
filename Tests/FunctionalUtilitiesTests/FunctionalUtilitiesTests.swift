//
//  FunctionalUtilitiesTest.swift
//  FunctionalUtilitiesTest
//
//  Created by Ляпин Михаил on 17.03.2024.
//

import XCTest
@testable import FunctionalUtilities

final class FunctionalUtilitiesTest: XCTestCase {

    var funcUtils: FunctionalUtilities!
    var testClosureWithDoubleArgument: ((Double) -> Double)!
    var testClosureWithFloatArgument: ((Float) -> Float)!
    var isValidDoubleArgument: ((Double, Double, Double?) -> Bool)!
    var isValidFloatArgument: ((Float, Float, Float?) -> Bool)!
    
    override func setUpWithError() throws {
        funcUtils = FunctionalUtilities()
        testClosureWithDoubleArgument = { x in
            x * 1024.0 * 2.0
        }
        testClosureWithFloatArgument = { x in
            x * 1024.0 * 2.0
        }
        isValidDoubleArgument = { result, limit, threshold in
            result <= limit && result >= (limit - (threshold ?? limit * 0.1))
            
        }
        isValidFloatArgument = { result, limit, threshold in
            result <= limit && result >= (limit - (threshold ?? limit * 0.1))
        }
    }
    
    func testGetOptimalArgumentDouble1() throws {
        let limit: Double = 1024
        let threshold: Double = 100
    
        let optimalArg = try funcUtils.getOptimalArgument(forClosure: testClosureWithDoubleArgument,
                                                          withResultLimit: limit,
                                                          threshold: threshold)
        let result = testClosureWithDoubleArgument(optimalArg)
        XCTAssertTrue(
            isValidDoubleArgument(result, limit, threshold),
            "Tested arg: \(optimalArg), got result: \(result)"
        )
    }
    
    func testGetOptimalArgumentDouble2() throws {
        let limit: Double = 1024
        let threshold: Double = 2048
        
        XCTAssertThrowsError(try funcUtils.getOptimalArgument(forClosure: testClosureWithDoubleArgument,
                                                          withResultLimit: limit,
                                                          threshold: threshold))
    }
    
    func testGetOptimalAgrumentDoube3() throws {
        let limit: Double = 1024 * 1024
        let range: ClosedRange<Double> = 0...1
        
        let optimalArg = try funcUtils.getOptimalArgument(forClosure: testClosureWithDoubleArgument,
                                                          withResultLimit: limit,
                                                          range: range)
        let result = testClosureWithDoubleArgument(optimalArg)
        XCTAssertTrue(
            isValidDoubleArgument(result, limit, nil) || optimalArg == range.upperBound,
            "Tested with optimal arg: \(optimalArg), got result: \(result)"
        )
    }
    
    func testGetOptimalArgumentFloat1() throws {
        let limit: Float = 1024
        let threshold: Float = 100
    
        let optimalArg = try funcUtils.getOptimalArgument(forClosure: testClosureWithFloatArgument,
                                                          withResultLimit: limit,
                                                          threshold: threshold)
        let result = testClosureWithFloatArgument(optimalArg)
        XCTAssertTrue(
            isValidFloatArgument(result, limit, threshold),
            "Tested arg: \(optimalArg), got result: \(result)"
        )
    }
    
    func testGetOptimalArgumentFloat2() throws {
        let limit: Float = 1024
        let threshold: Float = 2048
        
        XCTAssertThrowsError(try funcUtils.getOptimalArgument(forClosure: testClosureWithFloatArgument,
                                                          withResultLimit: limit,
                                                          threshold: threshold))
    }
    
    func testGetOptimalArgumentFloat3() throws {
        let limit: Float = 1024 * 1024
        let range: ClosedRange<Float> = 0...1
        
        let optimalArg = try funcUtils.getOptimalArgument(forClosure: testClosureWithFloatArgument,
                                                          withResultLimit: limit,
                                                          range: range)
        let result = testClosureWithFloatArgument(optimalArg)
        XCTAssertTrue(
            isValidFloatArgument(result, limit, nil) || optimalArg == range.upperBound,
            "Tested with optimal arg: \(optimalArg), got result: \(result)"
        )
    }

    func testPerformanceGetOptimalArgument() throws {
        // This is an example of a performance test case.
        measure {
            let limit: Double = 1024 * 1024
            let range: ClosedRange<Double> = 0...1
            
            do {
                let optimalArg = try funcUtils.getOptimalArgument(forClosure: testClosureWithDoubleArgument,
                                                                  withResultLimit: limit,
                                                                  range: range)
                let result = testClosureWithDoubleArgument(optimalArg)
                XCTAssertTrue(
                    isValidDoubleArgument(result, limit, nil) || optimalArg == range.upperBound,
                    "Tested with optimal arg: \(optimalArg), got result: \(result)"
                )
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

}
