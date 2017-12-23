//
//  Mondrian.swift
//  Art-in-a-Box
//
//  Created by Michael Kühweg on 18.12.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import Foundation

class Mondrian {
    
    let lowerBoundForRandomSplits = 6
    let upperBoundForRandomSplits = 16
    
    let lowerBoundForColouredBoxes = 3
    let upperBoundForColouredBoxes = 10
    
    let virtualPartsOfAspect = 1000
    
    let virtualMinimalBoxSizeInPartsOfAspect = 50
    
    let lowerBoundForLineThicknessInPartsOfAspect = 5
    let upperBoundForLineThicknessInPartsOfAspect = 16
    
    private var boxes: [ColouredBox]
    private var lineThickness: Int
    
    init() {
        boxes = []
        lineThickness = 16
    }
    
    public func randomArtwork() {
        boxes = randomColours(boxes: randomBoxes())
        lineThickness = randomLineThickness()
    }
    
    public func scaledTo(aspectSize: Int) -> [ColouredBox] {
        var scaledBoxes = [ColouredBox]()
        let scaleFactor = aspectSize * virtualMinimalBoxSizeInPartsOfAspect / virtualPartsOfAspect
        for colouredBox in boxes {
            let box = colouredBox.box
            let scaledBox = MondrianBox(
                topLeft: Point(x: box.topLeft.x * scaleFactor,
                               y: box.topLeft.y * scaleFactor),
                bottomRight: Point(x: (box.bottomRight.x + 1) * scaleFactor - 1,
                                   y: (box.bottomRight.y + 1) * scaleFactor - 1))
            scaledBoxes.append(ColouredBox(box: scaledBox, colour: colouredBox.colour))
        }
        return scaledBoxes
    }
    
    public func recommendedLineThicknessForScale(aspectSize: Int) -> Int {
        return aspectSize * lineThickness / virtualPartsOfAspect
    }
    
    public func backgroundBox() -> MondrianBox {
        return MondrianBox(topLeft: Point(x: 0, y: 0), bottomRight: Point(x: virtualGridSize(), y: virtualGridSize()))
    }
    
    public func splitBetweenPoints(boxes: [MondrianBox], point1: Point, point2: Point) -> [MondrianBox] {
        guard point1.x == point2.x || point1.y == point2.y else { return boxes }
        var newBoxes = [MondrianBox]()
        let splitHorizontally = point1.y == point2.y
        for box in boxes {
            if splitHorizontally {
                if horizontalRange(start: point1.x, end: point2.x, concerns: box) {
                    newBoxes.append(contentsOf: box.splitAlongHorizontalLineAt(y: point1.y))
                } else {
                    newBoxes.append(box)
                }
            } else {
                if verticalRange(start: point1.y, end: point2.y, concerns: box) {
                    newBoxes.append(contentsOf: box.splitAlongVerticalLineAt(x: point1.x))
                } else {
                    newBoxes.append(box)
                }
            }
        }
        return newBoxes
    }
    
    public func horizontalRange(start: Int, end: Int, concerns box: MondrianBox) -> Bool {
        let insideStart = box.topLeft.x...box.topRight.x ~= min(start, end)
        let insideEnd = box.topLeft.x...box.topRight.x ~= max(start, end)
        let across = min(start, end) <= box.topLeft.x && max(start, end) >= box.topRight.x
        return insideStart || insideEnd || across
    }
    
    public func verticalRange(start: Int, end: Int, concerns box: MondrianBox) -> Bool {
        let insideStart = box.topLeft.y...box.bottomLeft.y ~= min(start, end)
        let insideEnd = box.topLeft.y...box.bottomLeft.y ~= max(start, end)
        let across = min(start, end) <= box.topLeft.y && max(start, end) >= box.bottomLeft.y
        return insideStart || insideEnd || across
    }
    
    private func randomLineThickness() -> Int {
        return lowerBoundForLineThicknessInPartsOfAspect + Int(arc4random_uniform(UInt32(upperBoundForLineThicknessInPartsOfAspect - lowerBoundForLineThicknessInPartsOfAspect)))
    }
    
    private func randomColours(boxes: [MondrianBox]) -> [ColouredBox] {
        var colouredBoxes = [ColouredBox]()
        for box in boxes {
            colouredBoxes.append(ColouredBox(box: box, colour: .white))
        }
        let randomNumberOfBoxesToFillWithColour = lowerBoundForColouredBoxes + Int(arc4random_uniform(UInt32(upperBoundForColouredBoxes - lowerBoundForColouredBoxes)))
        for _ in 0...randomNumberOfBoxesToFillWithColour {
            let randomAt = Int(arc4random_uniform(UInt32(colouredBoxes.count)))
            colouredBoxes[randomAt].colour = MondrianColour.randomColourExceptWhite()
        }
        return colouredBoxes
    }
    
    private func randomBoxes() -> [MondrianBox] {
        let randomSplitNumber = lowerBoundForRandomSplits + Int(arc4random_uniform(UInt32(upperBoundForRandomSplits - lowerBoundForRandomSplits)))
        var boxes = [backgroundBox()]
        for _ in 0..<randomSplitNumber {
            boxes = randomSplit(boxes: boxes)
        }
        return boxes
    }
    
    private func randomSplit(boxes: [MondrianBox]) -> [MondrianBox] {
        let splitHorizontally = randomBool()
        let randomSplitSpanStart = Int(arc4random_uniform(UInt32(virtualGridSize())))
        let randomSplitSpanEnd = Int(arc4random_uniform(UInt32(virtualGridSize())))
        let randomSplitPosition = Int(arc4random_uniform(UInt32(virtualGridSize())))
        let x1 = splitHorizontally ? randomSplitSpanStart : randomSplitPosition
        let y1 = splitHorizontally ? randomSplitPosition : randomSplitSpanStart
        let x2 = splitHorizontally ? randomSplitSpanEnd : randomSplitPosition
        let y2 = splitHorizontally ? randomSplitPosition : randomSplitSpanEnd
        return splitBetweenPoints(boxes: boxes,
                                  point1: Point(x: x1, y: y1),
                                  point2: Point(x: x2, y: y2))
    }
    
    private func virtualGridSize() -> Int {
        return virtualPartsOfAspect / virtualMinimalBoxSizeInPartsOfAspect
    }
    
    private func randomBool() -> Bool {
        // not the modulo 2 variant... that seems a bit biased (despite the _uniform)
        return arc4random_uniform(10) < 5
    }
}
