//
//  MondrianToImage.swift
//  Art-in-a-Box
//
//  Created by Michael Kühweg on 22.12.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import UIKit

class MondrianOnCanvas {
    
    let mondrian: Mondrian
    let canvasSize: Int
    
    // Our random art always comes as a square, not a general rectangle
    init(mondrian: Mondrian, canvasSize: Int) {
        self.mondrian = mondrian
        self.canvasSize = canvasSize
    }
    
    public func asImage() -> UIImage {
        let imageSize = CGSize(width: canvasSize, height: canvasSize)
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        for box in mondrian.scaledTo(aspectSize: canvasSize) {
            drawBox(box: box, inContext: context)
        }
        for box in mondrian.scaledTo(aspectSize: canvasSize) {
            drawLinesAroundBox(box: box, inContext: context)
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    private func drawBox(box: ColouredBox, inContext context: CGContext) {
        let bareBox = box.box
        let boxToPaint = CGRect(x: bareBox.topLeft.x, y: bareBox.topLeft.y, width: bareBox.width, height: bareBox.height)
        context.saveGState()
        context.setFillColor(translateColour(fromMondrianColour: box.colour))
        // lines will be painted separately
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setLineWidth(CGFloat(0))
        
        context.addRect(boxToPaint)
        context.drawPath(using: .fill)
        context.restoreGState()
    }
    
    private func translateColour(fromMondrianColour colour: MondrianColour) -> CGColor {
        switch colour {
        case .red:
            return UIColor.red.cgColor
        case .blue:
            return UIColor.blue.cgColor
        case .yellow:
            return UIColor.yellow.cgColor
        case .black:
            return UIColor.black.cgColor
        default:
            return UIColor.white.cgColor
        }
    }
    
    private func drawLinesAroundBox(box: ColouredBox, inContext context: CGContext) {
        context.saveGState()
        let lineWidth = mondrian.recommendedLineThicknessForScale(aspectSize: canvasSize)
        context.setLineWidth(CGFloat(lineWidth))
        context.setStrokeColor(UIColor.black.cgColor)
        topLine(box: box, lineWidth: lineWidth)?.stroke()
        rightLine(box: box, lineWidth: lineWidth)?.stroke()
        bottomLine(box: box, lineWidth: lineWidth)?.stroke()
        leftLine(box: box, lineWidth: lineWidth)?.stroke()
        context.restoreGState()
    }
    
    private func basicLine(fromX: Int, fromY: Int, toX: Int, toY: Int, lineWidth: Int) -> UIBezierPath? {
        let line = UIBezierPath()
        line.move(to: CGPoint(x: fromX, y: fromY))
        line.addLine(to: CGPoint(x: toX, y: toY))
        line.lineWidth = CGFloat(lineWidth)
        line.lineCapStyle = CGLineCap.square
        line.close()
        return line
    }
    
    private func topLine(box: ColouredBox, lineWidth: Int) -> UIBezierPath? {
        let bareBox = box.box
        guard bareBox.topLeft.y > 0 else { return nil }
        return basicLine(fromX: bareBox.topLeft.x,
                         fromY: bareBox.topLeft.y,
                         toX: bareBox.topRight.x,
                         toY: bareBox.topRight.y,
                         lineWidth: lineWidth)
    }
    
    private func rightLine(box: ColouredBox, lineWidth: Int) -> UIBezierPath? {
        let bareBox = box.box
        guard bareBox.topRight.x < canvasSize - 1 else { return nil }
        return basicLine(fromX: bareBox.topRight.x,
                         fromY: bareBox.topRight.y,
                         toX: bareBox.bottomRight.x,
                         toY: bareBox.bottomRight.y,
                         lineWidth: lineWidth)
    }
    
    private func bottomLine(box: ColouredBox, lineWidth: Int) -> UIBezierPath? {
        let bareBox = box.box
        guard bareBox.bottomLeft.y < canvasSize - 1 else { return nil }
        return basicLine(fromX: bareBox.bottomLeft.x,
                         fromY: bareBox.bottomLeft.y,
                         toX: bareBox.bottomRight.x,
                         toY: bareBox.bottomRight.y,
                         lineWidth: lineWidth)
    }
    
    private func leftLine(box: ColouredBox, lineWidth: Int) -> UIBezierPath? {
        let bareBox = box.box
        guard bareBox.topLeft.x > 0 else { return nil }
        return basicLine(fromX: bareBox.topLeft.x,
                         fromY: bareBox.topLeft.y,
                         toX: bareBox.bottomLeft.x,
                         toY: bareBox.bottomLeft.y,
                         lineWidth: lineWidth)
    }
}

