# Switches
A sample application used to discuss Switch Statements in Swift

![Centering](http://i.imgur.com/6xHZidt.gif "Centering")

## Scrolling Action Triggers Switch Statement
```
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
```

## Navigation Button Actions
```
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
```

![IBActions](http://i.imgur.com/1wYGliq.gif "IBActions")
![Bottom Anchor](http://i.imgur.com/HOpxRcz.gif "Bottom Anchor")
![Demo](http://i.imgur.com/W9lHjC0.gif "Demo")
