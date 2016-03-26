//
//  ViewController.swift
//  Switches
//
//  Created by Daniel Burke on 3/21/16.
//  Copyright © 2016 D2 Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var viewWidth:CGFloat = 0
    var currentIndex:Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //Switches: Common users, Pattern Matching
    //Storyboard: Anchor, Center, 50%, Animate Constraints
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.cornerRadius = 60
        logoImageView.clipsToBounds = true
        
        //Listen for orientation changes
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.deviceDidRotate(_:)),
                                                         name: UIDeviceOrientationDidChangeNotification,
                                                         object: nil)
    }
    
    func deviceDidRotate(notification: NSNotification) {
        //Update width, contentSize, and offset on rotate
        viewWidth = self.view.frame.size.width
        scrollView.contentSize = CGSizeMake(viewWidth*4, self.view.frame.size.height)
        let newOffsetX = viewWidth * CGFloat(currentIndex)
        scrollView.setContentOffset(CGPointMake(newOffsetX, 0), animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        viewWidth = self.view.frame.size.width
        
        //Content size must be set if the subviews aren't
        //using AutoLayout.  The scrollView can't 
        //calculate it's true content size
        scrollView.contentSize = CGSizeMake(viewWidth*4, self.view.frame.size.height)
        currentIndex = Int(scrollView.contentOffset.x / viewWidth)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("Offset X: \(scrollView.contentOffset.x)")
    }
}

