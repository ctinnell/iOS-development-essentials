//
//  WordCloudView.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 12/24/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class WordCloudView: UIView {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let context = UIGraphicsGetCurrentContext() {
            flipCoordinateSystem(context)
            drawText(context, text: NSAttributedString(string: "Word Number 1"), x: 100.0, y: 600.0)
        }
    }
    
    func flipCoordinateSystem(context: CGContextRef) {
        // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    
    func drawText(context: CGContextRef, text: NSAttributedString, x: Double, y: Double) {
        let text = NSAttributedString(string: "Word Number 1")
        let line = CTLineCreateWithAttributedString(text)
        
        CGContextSetTextPosition(context, CGFloat(x), CGFloat(y));
        CTLineDraw(line, context);
        
    }
}
