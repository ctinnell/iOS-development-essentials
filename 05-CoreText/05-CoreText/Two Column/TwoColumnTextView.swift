//
//  TwoColumnTextView.swift
//  05-CoreText
//
//  Created by Clay Tinnell on 1/1/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class TwoColumnTextView: UIView {

    var text: String?
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if let context = UIGraphicsGetCurrentContext() {
            drawText(context)
        }
    }
    
    private func flipCoordinateSystem(context: CGContextRef) {
        // Flip the coordinate system
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
    }
    
    private func drawText(context: CGContextRef) {
        guard let text = text, font = UIFont(name: "Helvetica", size: 15.0) else { return }
        
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName:font])
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedText)

        //Configure Left Column
        let leftColumnPath = CGPathCreateMutable()
        let leftColumnRect = CGRectMake(0, 0, self.bounds.size.width / 2.0, self.bounds.size.height - 75.0)
        CGPathAddRect(leftColumnPath, nil, leftColumnRect)
        let leftFame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), leftColumnPath, nil)
        
        //Configure Right Column
        let rightColumnPath = CGPathCreateMutable()
        let rightColumnRect = CGRectMake(self.bounds.size.width / 2.0, 0, self.bounds.size.width/2.0, self.bounds.size.height - 75.0)
        CGPathAddRect(rightColumnPath, nil, rightColumnRect)
        let rightFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(CTFrameGetVisibleStringRange(leftFame).length,0), rightColumnPath, nil)
        
        flipCoordinateSystem(context)
        
        CTFrameDraw(leftFame, context)
        CTFrameDraw(rightFrame, context)
    }
}
