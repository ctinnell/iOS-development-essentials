//
//  WordCloudView.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 12/24/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class WordCloudView: UIView {
    
    enum WordCloudDrawingDirection {
        case Left
        case Right
        case Up
        case Down
        
        func switchDirection() -> WordCloudDrawingDirection {
            switch self {
            case .Left:
                return .Up
            case .Right:
                return .Down
            case .Up:
                return .Right
            case .Down:
                return .Left
            }
        }
    }
    
    private var drawingDirection = WordCloudDrawingDirection.Right
    
    private var xAdjustmentDirection = WordCloudDrawingDirection.Right
    private var yAdjustmentDirection = WordCloudDrawingDirection.Up
    
    private var wordsPerLine = 1.0
    private var wordCount = 0.0

    var wordCloudItems: [WordCloudParser.WordCloudElement]?
    
    //MARK: - UIView
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let context = UIGraphicsGetCurrentContext() {
            flipCoordinateSystem(context)
            drawItems(context)
        }
    }
    
    //MARK: - Draw Items / Main Entry Point
    private func drawItems(context: CGContextRef) {
        var (x,y) = center()
        let factor = 25.0
        
        if let wordCloudItems = wordCloudItems?[0..<100] {
            for (var index=0; index<wordCloudItems.count; index++) {
                drawItem(context, itemIndex: index, x: x, y: y)
                if let bounds = self.wordCloudItems?[index].bounds {
                    if (movingHorizontally()) {
                        (x,y) = move(x, y: y, factor: max(factor,Double(bounds.width + 20.0)))
                    }
                    else {
                        (x,y) = move(x, y: y, factor: max(factor,Double(bounds.height + 5.0)))
                   }
                }
            }
        }
    }
    
    //MARK: - Moving and Navigation
    
    private func center() -> (Double, Double) {
        return (Double(self.bounds.size.width / 2.0), Double(self.bounds.size.height / 2.0))
    }
    
    private func movingHorizontally() -> Bool {
        return (drawingDirection == .Left || drawingDirection == .Right)
    }
    
    private func move(x: Double, y: Double, factor: Double) -> (Double, Double) {
        var x=x, y=y
        wordCount++

        if wordCount >= wordsPerLine {
            wordCount = 0
            if (movingHorizontally()) {
                wordsPerLine++
            }
            (x,y) = moveInDirection(drawingDirection.switchDirection(),x: x, y: y, factor: factor)
        }
        else {
            (x,y) = moveInDirection(drawingDirection,x: x, y: y, factor: factor)
        }
        
        return (x,y)
    }
    
    private func moveInDirection(direction: WordCloudDrawingDirection, x: Double, y: Double, factor: Double) -> (Double, Double) {
        switch direction {
        case .Right:
            return moveRight(x, y: y, factor: factor)
        case .Left:
            return moveLeft(x, y: y, factor: factor)
        case .Down:
            return moveDown(x, y: y, factor: factor)
        case .Up:
            return moveUp(x, y: y, factor: factor)
        
        }
    }
    
    private func moveRight(x: Double, y: Double, factor: Double) -> (Double,Double) {
        drawingDirection = .Right
        return (x+factor,y)
    }

    private func moveDown(x: Double, y: Double, factor: Double) -> (Double,Double) {
        drawingDirection = .Down
        return (x,y-factor)
    }
    
    private func moveLeft(x: Double, y: Double, factor: Double) -> (Double,Double) {
        drawingDirection = .Left
        return (x-factor,y)
    }

    private func moveUp(x: Double, y: Double, factor: Double) -> (Double,Double) {
        drawingDirection = .Up
        return (x,y+factor)
    }
    
    // MARK: - Core Text Drawing
    
    private func wordColor() -> UIColor {
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private func flipCoordinateSystem(context: CGContextRef) {
        // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    
    
    private func drawItem(context: CGContextRef, itemIndex: Int, x: Double, y: Double) {
        if let item = wordCloudItems?[itemIndex] {
            if let font = UIFont(name: "Helvetica", size: CGFloat(10 * item.count)) {
                let text = NSMutableAttributedString(string: item.word, attributes: [NSFontAttributeName:font])
                text.addAttribute(NSForegroundColorAttributeName, value: wordColor(), range:NSRange(location: 0, length: text.length))
                var bounds = CGRect(x: CGFloat(min(max(x,22.0), Double(self.bounds.size.width - 25.0))), y: CGFloat(min(max(y, 22.0),Double(self.bounds.size.height - 25.0))), width: text.size().width, height: text.size().height)
                configureXAdjustmentDirection(bounds.origin.x)
                configureYAdjustmentDirection(bounds.origin.y)
                var intersect = true
                while intersect {
                   intersect = boundsIntersectsAnotherItem(bounds)
                    if intersect {
                        bounds = adjustedBoundsForIntersect(bounds)
                    }
                    else {
                        self.wordCloudItems?[itemIndex].bounds = bounds
                        drawText(context, text: text, x: Double(bounds.origin.x), y: Double(bounds.origin.y))
                    }
                }
            }
        }
    }
    
    private func drawText(context: CGContextRef, text: NSAttributedString, x: Double, y: Double) {
        let line = CTLineCreateWithAttributedString(text)
        CGContextSetTextPosition(context, CGFloat(x), CGFloat(y));
        CTLineDraw(line, context);
    }
    
    // MARK: - Intersect detection and adjustment
    
    private func boundsIntersectsAnotherItem(bounds: CGRect) -> Bool {
        var intersects = false
        var counter = 0
        if let wordCloudItems = wordCloudItems {
            for item in wordCloudItems {
                counter++
                if let otherItemBounds = item.bounds {
                    if CGRectIntersectsRect(bounds, otherItemBounds) {
                        intersects = true
                        break
                    }
                    else if counter > 1000 {
                        intersects = false
                        break
                    }
                }
            }
        }
        return intersects
    }
    
    private func adjustedBoundsForIntersect(bounds: CGRect) -> CGRect {
        var newX = bounds.origin.x
        var newY = bounds.origin.y
        
        let factor: CGFloat = 10.0
        newX = adjustedXConstrainedToView(newX, factor: factor)
        
        newY = adjustedYConstrainedToView(newY, factor: factor)
        
        return CGRect(x: newX, y: newY, width: bounds.size.width, height: bounds.size.height)
    }
    
    private func configureXAdjustmentDirection(x: CGFloat) {
        let (centerX,_) = center()
        var direction: WordCloudDrawingDirection = .Right
        if x > CGFloat(centerX) {
            direction = .Left
        }
        xAdjustmentDirection = direction
    }
    
    private func configureYAdjustmentDirection(y: CGFloat) {
        let (_,centerY) = center()
        var direction: WordCloudDrawingDirection = .Down
        if y > CGFloat(centerY) {
            direction = .Up
        }
        yAdjustmentDirection = direction
    }
    
    private func adjustedXConstrainedToView(x: CGFloat, factor: CGFloat) -> CGFloat {
        var adjustedX = x
        if xAdjustmentDirection == .Right {
            if x+factor <= self.bounds.width - 25.0 {
                adjustedX = x + factor
            }
            else {
                adjustedX = x - factor
                xAdjustmentDirection = .Left
            }
        }
        else {
            if x-factor > 0.0 {
                adjustedX = x-factor
            }
            else {
                adjustedX = x+factor
                xAdjustmentDirection = .Right
            }
        }
        return adjustedX
    }
    
    private func adjustedYConstrainedToView(y: CGFloat, factor: CGFloat) -> CGFloat {
        var adjustedY = y
        if yAdjustmentDirection == .Up {
            if y+factor <= self.bounds.height - 25.0 {
                adjustedY = y + factor
            }
            else {
                adjustedY = y - factor
                yAdjustmentDirection = .Down
            }
        }
        else {
            if y-factor > 75.0 {
                adjustedY = y - factor
            }
            else {
                adjustedY = y + factor
                yAdjustmentDirection = .Up
            }
        }
        return adjustedY
    }
    
}
