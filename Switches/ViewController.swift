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
    @IBOutlet weak var bottomButtonBottomConstraint: NSLayoutConstraint!
    
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
        
        if prevButton != nil && nextButton != nil {
            //Update the view based on the scrollView position
            switch scrollView.contentOffset.x {
            case 0:
                prevButton.hidden = true;
            case 0..<viewWidth:
                prevButton.hidden = false;
                prevButton.alpha = scrollView.contentOffset.x / viewWidth
                
                //Fade Out
                logoImageView.alpha = 1 - (scrollView.contentOffset.x / viewWidth)
                
                //Fade In
                userLabel.alpha = scrollView.contentOffset.x / viewWidth
                
            case viewWidth..<viewWidth*2:
                userLabel.alpha = 1 - (scrollView.contentOffset.x - viewWidth) / viewWidth
                messageLabel.alpha = (scrollView.contentOffset.x - viewWidth) / viewWidth
                
            case viewWidth*2..<viewWidth*3:
                nextButton.hidden = false;
                nextButton.alpha = 1 - (scrollView.contentOffset.x - viewWidth*2) / viewWidth
                messageLabel.alpha = 1 - (scrollView.contentOffset.x - viewWidth*2) / viewWidth
                sendLabel.alpha = (scrollView.contentOffset.x - viewWidth*2) / viewWidth
                bottomButtonBottomConstraint.constant = -50 * (1 - (scrollView.contentOffset.x - viewWidth*2) / viewWidth)
            case viewWidth*3:
                nextButton.hidden = true;
                
            default:
                //() //Do nothing in this case
                //
                print("wasted cycles")
            }
            
            //Update current index
            currentIndex = Int(scrollView.contentOffset.x / viewWidth)
        }
    }
    
    //Don't use 0 as a tag ID
    @IBAction func navigate(sender: AnyObject) {
        if sender.isKindOfClass(UIButton) {
            let button = sender as! UIButton
            currentIndex = Int(scrollView.contentOffset.x / viewWidth)
            var newOffsetX:CGFloat = 0.0
            
            switch (currentIndex, button.tag) {
            case (1...4, 1):
                newOffsetX = viewWidth * CGFloat(currentIndex - 1)
            case (0...3, 2):
                newOffsetX = viewWidth * CGFloat(currentIndex + 1)
            default:
                print("nothing")
            }
            
            //Animate to scroll position
            scrollView.setContentOffset(CGPointMake(newOffsetX, 0), animated: true)
        }
        
    }
}

