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
        
        func switchDirction() -> WordCloudDrawingDirection {
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
        var x = Double(self.bounds.size.width / 2.0)
        var y = Double(self.bounds.size.height / 2.0)
        let factor = 25.0
        
        if let wordCloudItems = wordCloudItems?[0..<100] {
            for item in wordCloudItems {
                drawItem(context, item: item, x: x, y: y)
                (x,y) = move(x, y: y, factor: factor)
            }
        }
    }
    
    //MARK: - Moving and Navigation
    private func move(x: Double, y: Double, factor: Double) -> (Double, Double) {
        var x=x, y=y
        if wordCount >= wordsPerLine {
            (x,y) = moveInDirection(drawingDirection.switchDirction(),x: x, y: y, factor: factor)
            wordCount = 0
            wordsPerLine++
        }
        else {
            (x,y) = moveInDirection(drawingDirection,x: x, y: y, factor: factor)
            wordCount++
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

    
//    func sizeForAttributedString(string: NSAttributedString) -> CGSize {
//        let frameSetter = CTFramesetterCreateWithAttributedString(string)
//        
//    }
    
    // MARK: - Core Text Drawing
    private func flipCoordinateSystem(context: CGContextRef) {
        // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    
    
    private func drawItem(context: CGContextRef, item: WordCloudParser.WordCloudElement, x: Double, y: Double) {
        if let font = UIFont(name: "Helvetica", size: CGFloat(10 * item.count)) {
            let text = NSAttributedString(string: item.word, attributes: [NSFontAttributeName:font])
            drawText(context, text: text, x: x, y: y)
        }
    }
    
    private func drawText(context: CGContextRef, text: NSAttributedString, x: Double, y: Double) {
        let line = CTLineCreateWithAttributedString(text)
        CGContextSetTextPosition(context, CGFloat(x), CGFloat(y));
        CTLineDraw(line, context);
    }
}
