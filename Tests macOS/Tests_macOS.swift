//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Katelyn Lydeen on 1/31/22.
//

import XCTest
@testable import Quadratic_Equation

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testQuadraticInitialization() async {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = 1.0
        let b = 1.0
        let c = -2.0
            
        let myQuadratic = QuadraticEquation()
        let _ = await myQuadratic.initWithValues(passedA: a, passedB: b, passedC: c)
            
        let x1 = myQuadratic.x1
        let x2 = myQuadratic.x2
        let x1Prime = myQuadratic.x1Prime
        let x2Prime = myQuadratic.x2Prime
        XCTAssertEqual(x1, 1, accuracy: 1.0E-7, "Was not equal to this resolution.")
        XCTAssertEqual(x2, -2, accuracy: 1.0E-7, "Was not equal to this resolution.")
        XCTAssertEqual(x1Prime, 1, accuracy: 1.0E-7, "Was not equal to this resolution.")
        XCTAssertEqual(x2Prime, -2, accuracy: 1.0E-7, "Was not equal to this resolution.")
    }
    
    func testCalculateX1() async {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = 1.0
        let b = 1.0
        let c = -2.0
            
        let myQuadratic = QuadraticEquation()

        let x1 = await myQuadratic.calculateX1(a: a, b: b, c: c)
            
        XCTAssertEqual(x1, 1, accuracy: 1.0E-7, "Was not equal to this resolution.")
    }
    
    func testCalculateX2() async {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = 1.0
        let b = 1.0
        let c = -2.0
            
        let myQuadratic = QuadraticEquation()

        let x2 = await myQuadratic.calculateX2(a: a, b: b, c: c)
            
        XCTAssertEqual(x2, -2, accuracy: 1.0E-7, "Was not equal to this resolution.")
    }
    
    func testCalculateX1Prime() async {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = 1.0
        let b = 1.0
        let c = -2.0
            
        let myQuadratic = QuadraticEquation()

        let x1Prime = await myQuadratic.calculateX1Prime(a: a, b: b, c: c)
            
        XCTAssertEqual(x1Prime, 1, accuracy: 1.0E-7, "Was not equal to this resolution.")
    }
    
    func testCalculateX2Prime() async {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let a = 1.0
        let b = 1.0
        let c = -2.0
            
        let myQuadratic = QuadraticEquation()

        let x2Prime = await myQuadratic.calculateX2Prime(a: a, b: b, c: c)
            
        XCTAssertEqual(x2Prime, -2, accuracy: 1.0E-7, "Was not equal to this resolution.")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
