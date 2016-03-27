# Switches
#### A sample application used to discuss Switch Statements in Swift
Switch statements are super-charged in Swift for iOS powered by Pattern Matching. This tutorial is part of an *Intro to Swift* series and includes a basic Intro to Storyboards.

## Switch Power
Here are few new tricks you can use in Swift:

### Ranges
You can provide a range as a `case` and Swift will determine whether or not the provided value is found within that range. Notice the use of `...` for inclusive ranges and `..<` for exclusive.
```
switch (value) {
    case 1...4:
        print("Catches values from 1 to 4")
    case 5:
        print("Catches exactly 5")
    case 6..<10:
        print("Catches values from 6 to 10")
    default:
        print("nothing")
}
```

### Tuples
Tuples allow you to match against several values and even types.
```
switch (chapter, page){
    case ("Chapter One", 1):
        print("First chapter, first page")
    case ("Chapter One", 2):
        print("First chapter, second page")
    case ("Chapter Two", 1):
        print("Second chapter, first page")
    case ("Chapter Two", 2...5): //Tuples AND Ranges
        print("Second chapter, & a page from 2 to 5")
    default: ()
}
```
### Value Binding (Waaaaaat??)
When a value of a tuple is a `var` or constant using `let`, Swift assigns the appropriate value to that variable for use in the case statement. Crazy business.
```
switch (button.tag, page){
    case (1, 1):
        print("First button, first page")
    case (1, 2):
        print("First button, second page")
    //Here, we match on the tag of the button, and 
    //pass whatever the `index` is to the constant `x`
    case (2, let x): 
        print("Second button, page number \(x)")
    default: ()
}
```

## A basic exploration of Storyboards
### Simple Anchoring
One of the most common constraints is simply anchoring the various sides of a view to the edges of your `UIViewController.view`. In this example we anchor the `Leading`, `Trailing`, & `Bottom` edges of the button to the view, then we set the `Height` constraint. This will keep the button at the bottom, stretching across the full width of the view, but maintaining a constant height.

![Bottom Anchor](http://i.imgur.com/HOpxRcz.gif "Bottom Anchor")

## Centering Views
Our main logo/icon view will be centered horizontally. To do this, we have to set the `Width` and `Height` constraints as well. XCode won't be completely happy until we set the vertical constraint as well.  We do this with a simple `Top` constraint to the top of the view.

![Centering](http://i.imgur.com/6xHZidt.gif "Centering")

## Connecting IBActions
You can connect multiple buttons to one `@IBAction` method. In our method, we're determining which button was tapped by matching the `tag` value we assigned it in the storyboard. That value is matched inside a tuple so we can also check which "page" we're on.

![IBActions](http://i.imgur.com/1wYGliq.gif "IBActions")
## Scrolling Action Triggers Switch Statement
As the user scrolls the scrollView, we check to see where the horizontal offset falls. The various page/section icons fade in and out depending on which "page" the user has scrolled to.

```
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
            () 	//Do nothing in this case
            	//leaving this empty causes an error
        }
        
        //Update current index
        currentIndex = Int(scrollView.contentOffset.x / viewWidth)
    }
}
```

## Navigation Button Actions
Tapping the "Prev" and "Next" buttons will cause the scrollView to scroll between pages. A swtch statement with Ranges and Tuples lets us intelligently map which actions are triggered by which button and when, allowing us to properly navigate forward and backward.

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
            ()
        }
        
        //Animate to scroll position
        scrollView.setContentOffset(CGPointMake(newOffsetX, 0), animated: true)
    }
}
```
## Demo
If we properly wire up the Prev/Next buttons, anchoring them to the sides as well as the bottom button, properly center our logo/icons, and connect our buttons to the `navigate:` `@IBAction`, our demo app will properly lay itself out, transition on scroll, and navigate on button taps.

![Demo](http://i.imgur.com/W9lHjC0.gif "Demo")