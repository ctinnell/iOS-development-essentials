//
//  RoundButtonView.swift
//  06-TextKit
//
//  Created by Clay Tinnell on 1/11/16.
//  Copyright © 2016 Clay Tinnell. All rights reserved.
//

import UIKit

class RoundButtonView: UIView {
    
    var color: UIColor?
    var text: String?
    var actionBlock: (()->())?
    
    convenience init(frame: CGRect, color: UIColor, text: String, actionBlock: (()->())?) {
        self.init(frame: frame)
        self.color = color
        self.text = text
        self.actionBlock = actionBlock
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buttonPressed:"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(context, rect)
        if let color = color {
            CGContextSetFillColorWithColor(context, color.CGColor)
        }
        CGContextFillPath(context)
        addLabel()
    }
    
    func addLabel() {
        if let text = text {
            let label = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.text = text
            label.textColor = UIColor.whiteColor()
            self.addSubview(label)
        }
    }
    
    func buttonPressed(gesture: UITapGestureRecognizer) {
        if let actionBlock = actionBlock {
            actionBlock()
        }
        print("button pressed")
    }
}
