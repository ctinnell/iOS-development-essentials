//
//  BoxViewController.swift
//  03-Core Animation
//
//  Created by Clay Tinnell on 11/21/15.
//  Copyright © 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class BoxViewController: UIViewController {

    @IBOutlet weak var bluePanel: UIView!
    @IBOutlet weak var yellowPanel: UIView!
    @IBOutlet weak var redPanel: UIView!
    @IBOutlet weak var greenPanel: UIView!
    @IBOutlet weak var grayPanel: UIView!
    @IBOutlet weak var brownPanel: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var panels: [UIView]?
    
    var previousRotationSliderValue = 0.0;
    var previousSeparationSliderValue = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panels = [bluePanel, yellowPanel, redPanel, greenPanel, grayPanel, brownPanel]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        centerPanels()
        addPespective()
        transformPanels(50.0)
        rotate(45.0)
    }
    
    func centerPanels() {
        for panel in panels! {
            panel.center = CGPointMake(containerView.bounds.width/2, containerView.bounds.height/2)
        }
    }
    
    func addPespective() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        containerView.layer.sublayerTransform = perspective
    }
    
    func transformPanels(position: Double) {
        let adjustment = CGFloat(position)
        
        yellowPanel.layer.transform = CATransform3DMakeTranslation(0, 0, adjustment)
        
        var transform = CATransform3DMakeTranslation(adjustment, 0, 0)
        bluePanel.layer.transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0)
        
        transform = CATransform3DMakeTranslation(0, adjustment * -1, 0)
        redPanel.layer.transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 1, 0, 0)
        
        transform = CATransform3DMakeTranslation(0, adjustment, 0)
        greenPanel.layer.transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 1, 0, 0)

        transform = CATransform3DMakeTranslation(adjustment * -1, 0, 0)
        grayPanel.layer.transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 0, 1, 0)
        
        brownPanel.layer.transform = CATransform3DMakeTranslation(0, 0, adjustment * -1)
    }
    
    func rotate(degrees: Double) {
        let radians = CGFloat(degrees * M_PI/180)
        
        var perspective = CATransform3DRotate(containerView.layer.sublayerTransform, radians, 1, 0, 0)
        perspective = CATransform3DRotate(perspective, radians, 0, 1, 0)
        containerView.layer.sublayerTransform = perspective
    }
    

    @IBAction func rotationSliderValueChanged(sender: UISlider) {
        let sliderValue = Double(sender.value)
        rotate(sliderValue - previousRotationSliderValue)
        previousRotationSliderValue = sliderValue
    }
    

    @IBAction func separationSliderValueChanged(sender: UISlider) {
        let sliderValue = Double(sender.value)
        transformPanels(sliderValue)
    }
}
