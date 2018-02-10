//
//  MondrianPaintingElements.swift
//  Art-in-a-Box
//
//  Created by Michael Kühweg on 18.12.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

struct Point {
    var x: Int
    var y: Int
}

// MondrianBoxes have no rotation. That makes things a lot easier ;-)
struct MondrianBox {

    let topLeft: Point
    let bottomRight: Point

    var topRight: Point { return Point(x: bottomRight.x, y: topLeft.y) }
    var bottomLeft: Point { return Point(x: topLeft.x, y: bottomRight.y) }

    // width and height are defined as the difference between start and end point,
    // ignoring the spatial extent of the points
    var width: Int { return bottomRight.x - topLeft.x }
    var height: Int { return bottomRight.y - topLeft.y }
    
    init(topLeft: Point, bottomRight: Point) {
        // just in case the initial parameters should be passed in the wrong order,
        // make sure they represent what the property name says
        let minX = min(topLeft.x, bottomRight.x)
        let maxX = max(topLeft.x, bottomRight.x)
        let minY = min(topLeft.y, bottomRight.y)
        let maxY = max(topLeft.y, bottomRight.y)
        self.topLeft = Point(x: minX, y: minY)
        self.bottomRight = Point(x: maxX, y: maxY)
    }
    
    public func splitAlongVerticalLineAt(x: Int) -> [MondrianBox] {

        guard x > topLeft.x && x <= bottomRight.x else { return [self] }

        let leftBox = MondrianBox(topLeft: topLeft,
                                  bottomRight: Point(x: x - 1, y: bottomRight.y))
        let rightBox = MondrianBox(topLeft: Point(x: x, y: topLeft.y),
                                   bottomRight: bottomRight)
        return [leftBox, rightBox]
    }

    public func splitAlongHorizontalLineAt(y: Int) -> [MondrianBox] {

        guard y > topLeft.y && y <= bottomRight.y else { return [self] }

        let upperBox = MondrianBox(topLeft: topLeft,
                                   bottomRight: Point(x: topRight.x, y: y - 1))
        let lowerBox = MondrianBox(topLeft: Point(x: topLeft.x, y: y),
                                   bottomRight: bottomRight)
        return [upperBox, lowerBox]
    }
}

// Only a very limited palette is used for our art
enum MondrianColour {

    case red
    case yellow
    case blue
    case black
    case white

    public static func randomColourExceptWhite() -> MondrianColour {
        let random = Int(arc4random_uniform(UInt32(4)))
        switch random {
        case 0:
            return .red
        case 1:
            return .yellow
        case 2:
            return .blue
        default:
            return .black
        }
    }
}

struct ColouredBox {
    var box: MondrianBox
    var colour: MondrianColour
}
