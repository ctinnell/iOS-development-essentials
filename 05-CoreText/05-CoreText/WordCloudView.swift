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
    }
    
    var drawingDirection = WordCloudDrawingDirection.Right


    var wordCloudItems: [WordCloudParser.WordCloudElement]?
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let context = UIGraphicsGetCurrentContext() {
            flipCoordinateSystem(context)
            drawItems(context)
        }
    }
    
    func drawItems(context: CGContextRef) {
        var x = Double(self.bounds.size.width / 2.0)
        var y = Double(self.bounds.size.height / 2.0)
        let factor = 25.0
        
        var wordsPerLine = 1.0
        var wordCount = 0.0
        
        if let wordCloudItems = wordCloudItems {
            for item in wordCloudItems {
                drawItem(context, item: item, x: x, y: y)
                switch drawingDirection {
                case .Right:
                    if wordCount >= wordsPerLine {
                        (x,y) = moveDown(x, y: y, factor: factor)
                        drawingDirection = .Down
                        wordCount = 0
                        wordsPerLine++
                    }
                    else {
                        (x,y) = moveRight(x, y: y, factor: factor)
                        wordCount++
                    }
                case .Left:
                    if wordCount >= wordsPerLine {
                        (x,y) = moveUp(x, y: y, factor: factor)
                        drawingDirection = .Up
                        wordCount = 0
                        wordsPerLine++
                    }
                    else {
                        (x,y) = moveLeft(x, y: y, factor: factor)
                        wordCount++
                    }
                case .Down:
                    if wordCount >= wordsPerLine {
                        (x,y) = moveLeft(x, y: y, factor: factor)
                        drawingDirection = .Left
                        wordCount = 0
                        wordsPerLine++
                    }
                    else {
                        (x,y) = moveDown(x, y: y, factor: factor)
                        wordCount++
                    }
                case .Up:
                    if wordCount >= wordsPerLine {
                        (x,y) = moveRight(x, y: y, factor: factor)
                        drawingDirection = .Right
                        wordCount = 0
                        wordsPerLine++
                    }
                    else {
                        (x,y) = moveUp(x, y: y, factor: factor)
                        wordCount++
                    }
                }
        
            }
        }
    }
    
    func drawItem(context: CGContextRef, item: WordCloudParser.WordCloudElement, x: Double, y: Double) {
        let text = NSAttributedString(string: item.word)
        drawText(context, text: text, x: x, y: y)
    }
    
    func moveRight(x: Double, y: Double, factor: Double) -> (Double,Double) {
        return (x+factor,y)
    }

    func moveDown(x: Double, y: Double, factor: Double) -> (Double,Double) {
        return (x,y-factor)
    }
    
    func moveLeft(x: Double, y: Double, factor: Double) -> (Double,Double) {
        return (x-factor,y)
    }

    func moveUp(x: Double, y: Double, factor: Double) -> (Double,Double) {
        return (x,y+factor)
    }

    
//    func sizeForAttributedString(string: NSAttributedString) -> CGSize {
//        let frameSetter = CTFramesetterCreateWithAttributedString(string)
//        
//    }
    
    func flipCoordinateSystem(context: CGContextRef) {
        // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    
    func drawText(context: CGContextRef, text: NSAttributedString, x: Double, y: Double) {
        let line = CTLineCreateWithAttributedString(text)
        CGContextSetTextPosition(context, CGFloat(x), CGFloat(y));
        CTLineDraw(line, context);
    }
}
