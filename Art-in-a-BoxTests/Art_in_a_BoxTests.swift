//
//  Art_in_a_BoxTests.swift
//  Art-in-a-BoxTests
//
//  Created by Michael Kühweg on 20.12.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import XCTest
@testable import Art_in_a_Box

class Art_in_a_BoxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBasicSplitAlongHorizontalLine() {
        let box = MondrianBox(topLeft: Point(x: 0, y: 0), bottomRight: Point(x: 100, y: 100))
        XCTAssertEqual(1, box.splitAlongHorizontalLineAt(y: -1).count)
        XCTAssertEqual(1, box.splitAlongHorizontalLineAt(y: 0).count)
        XCTAssertEqual(1, box.splitAlongHorizontalLineAt(y: 101).count)
        
        XCTAssertEqual(2, box.splitAlongHorizontalLineAt(y: 1).count)
        XCTAssertEqual(2, box.splitAlongHorizontalLineAt(y: 100).count)
    }
    
    func testDetailedSplitAlongHorizontalLine() {
        let box = MondrianBox(topLeft: Point(x: 0, y: 0), bottomRight: Point(x: 100, y: 100))
        let boxes = box.splitAlongHorizontalLineAt(y: 1)
        let whereIsTheLowerSplit = min(boxes[0].bottomRight.y, boxes[1].bottomRight.y)
        let whereIsTheUpperSplit = max(boxes[0].topLeft.y, boxes[1].topLeft.y)
        XCTAssertEqual(0, whereIsTheLowerSplit)
        XCTAssertEqual(1, whereIsTheUpperSplit)
    }
    
    func testBasicSplitAlongVerticalLine() {
        let box = MondrianBox(topLeft: Point(x: 0, y: 0), bottomRight: Point(x: 100, y: 100))
        XCTAssertEqual(1, box.splitAlongVerticalLineAt(x: -1).count)
        XCTAssertEqual(1, box.splitAlongVerticalLineAt(x: 0).count)
        XCTAssertEqual(1, box.splitAlongVerticalLineAt(x: 101).count)
        
        XCTAssertEqual(2, box.splitAlongVerticalLineAt(x: 1).count)
        XCTAssertEqual(2, box.splitAlongVerticalLineAt(x: 100).count)
    }
    
    func testDetailedSplitAlongVerticalLine() {
        let box = MondrianBox(topLeft: Point(x: 0, y: 0), bottomRight: Point(x: 100, y: 100))
        let boxes = box.splitAlongVerticalLineAt(x: 1)
        let whereIsTheLowerSplit = min(boxes[0].bottomRight.x, boxes[1].bottomRight.x)
        let whereIsTheUpperSplit = max(boxes[0].topLeft.x, boxes[1].topLeft.x)
        XCTAssertEqual(0, whereIsTheLowerSplit)
        XCTAssertEqual(1, whereIsTheUpperSplit)
    }
    
    func testCalculatedProperties() {
        let box = MondrianBox(topLeft: Point(x: 0, y: 4), bottomRight: Point(x: 8, y: 16))
        XCTAssertEqual(8, box.topRight.x)
        XCTAssertEqual(4, box.topRight.y)
        XCTAssertEqual(0, box.bottomLeft.x)
        XCTAssertEqual(16, box.bottomLeft.y)
        
        XCTAssertEqual(8, box.width)
        XCTAssertEqual(12, box.height)
    }
    
    func testPropertiesNamedRight() {
        let box = MondrianBox(topLeft: Point(x: 8, y: 16), bottomRight: Point(x: 0, y: 4))
        XCTAssertEqual(0, box.topLeft.x)
        XCTAssertEqual(4, box.topLeft.y)
        XCTAssertEqual(8, box.bottomRight.x)
        XCTAssertEqual(16, box.bottomRight.y)
    }
    
    func testInitialMondrian() {
        let artwork = Mondrian()
        let boxes = artwork.scaledTo(aspectSize: 2000)
        XCTAssertEqual(0, boxes.count)
    }

    func testBasicMondrian() {
        let artwork = Mondrian()
        let box = artwork.backgroundBox()
        let boxesAfterDiagonalSplit = artwork.splitBetweenPoints(boxes: [box], point1: Point(x: 1, y: 1), point2: Point(x: 2, y: 2))
        XCTAssertEqual(1, boxesAfterDiagonalSplit.count)
        let boxesAfterHorizontalSplit = artwork.splitBetweenPoints(boxes: [box], point1: Point(x: 1, y: 1), point2: Point(x: 2, y: 1))
        XCTAssertEqual(2, boxesAfterHorizontalSplit.count)
        let boxesAfterVerticalSplit = artwork.splitBetweenPoints(boxes: [box], point1: Point(x: 1, y: 1), point2: Point(x: 1, y: 2))
        XCTAssertEqual(2, boxesAfterVerticalSplit.count)
    }

    func testDetailedMondrian() {
        let artwork = Mondrian()
        let box = artwork.backgroundBox()
        let boxesAfterHorizontalSplit = artwork.splitBetweenPoints(boxes: [box], point1: Point(x: 1, y: 1), point2: Point(x: 2, y: 1))
        let lowerY = min(boxesAfterHorizontalSplit[0].bottomRight.y, boxesAfterHorizontalSplit[1].bottomRight.y)
        let upperY = max(boxesAfterHorizontalSplit[0].topLeft.y, boxesAfterHorizontalSplit[1].topLeft.y)
        XCTAssertEqual(0, lowerY)
        XCTAssertEqual(1, upperY)
        
        let boxesAfterVerticalSplit = artwork.splitBetweenPoints(boxes: [box], point1: Point(x: 1, y: 1), point2: Point(x: 1, y: 2))
        let lowerX = min(boxesAfterVerticalSplit[0].bottomRight.x, boxesAfterVerticalSplit[1].bottomRight.x)
        let upperX = max(boxesAfterVerticalSplit[0].topLeft.x, boxesAfterVerticalSplit[1].topLeft.x)
        XCTAssertEqual(0, lowerX)
        XCTAssertEqual(1, upperX)
    }
    
    func testSplitTwice() {
        let artwork = Mondrian()
        let box = artwork.backgroundBox()
        // split once by a horizontal line at y = 10
        // should look like:
        // +----------------+
        // |                |
        // +----- split ----+
        // |                |
        // +----------------+
        let boxesAfterFirstSplit = artwork.splitBetweenPoints(boxes: [box], point1: Point(x: 10, y: 10), point2: Point(x: 20, y: 10))
        XCTAssertEqual(2, boxesAfterFirstSplit.count)
        // split once more - this time by a vertical line at x = 10
        // should look like:
        // +-----+----------+
        // |     | <- split |
        // +-----+----------+
        // |                |
        // +----------------+
        let boxesAfterSecondSplit = artwork.splitBetweenPoints(boxes: boxesAfterFirstSplit, point1: Point(x: 10, y: 1), point2: Point(x: 10, y: 2))
        XCTAssertEqual(3, boxesAfterSecondSplit.count)
        // just to be sure, a last one, again a horizontal line at y = 5
        let boxesAfterThirdSplit = artwork.splitBetweenPoints(boxes: boxesAfterSecondSplit, point1: Point(x: 1, y: 5), point2: Point(x: 2, y: 5))
        XCTAssertEqual(4, boxesAfterThirdSplit.count)
    }
    
    func testRangeChecks() {
        let artwork = Mondrian()
        let box = artwork.backgroundBox()
        // inside
        XCTAssertTrue(artwork.horizontalRange(start: box.topLeft.x + 1, end: box.topRight.x - 1, concerns: box))
        // starts inside, ends outside
        XCTAssertTrue(artwork.horizontalRange(start: box.topLeft.x, end: box.topRight.x + 1, concerns: box))
        // starts outside, ends inside
        XCTAssertTrue(artwork.horizontalRange(start: box.topLeft.x - 1, end: box.topRight.x - 1, concerns: box))
        // across
        XCTAssertTrue(artwork.horizontalRange(start: box.topLeft.x - 1, end: box.topRight.x + 1, concerns: box))
        // outside
        XCTAssertFalse(artwork.horizontalRange(start: box.topLeft.x - 2, end: box.topLeft.x - 1, concerns: box))
    }
}
