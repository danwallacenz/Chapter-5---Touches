//
//  FirstViewController.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "FirstViewController.h"
#import "DraggableView.h"
#import "HorizontalPanGestureRecognizer.h"
#import "VerticalPanGestureRecognizer.h"


@interface FirstViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet DraggableView *draggableView;

@property (weak, nonatomic) IBOutlet UIView *viewWithTapGestureRecognizers;
@property (weak, nonatomic) IBOutlet UITextView *viewWithTapGestureRecognizersTExtView;

@property (strong, nonatomic) UIColor *originalTextViewColor;
@property (strong, nonatomic) UIColor *originalViewWithTapGestureRecognizersColor;

@property (weak, nonatomic) IBOutlet UIView *viewWithPanGestureRecognizer;
@property CGPoint originalViewWithPanGestureRecognizerCenter;


@property (weak, nonatomic) IBOutlet UIView *viewWithUIPanGestureRecognizerWithUIKitDynamics;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;

@property (weak, nonatomic) IBOutlet UIView *horizontalAndVerticalDraggingView;

@property (weak, nonatomic) IBOutlet UITextView *tapAndHoldThenPanView;
@property (strong, nonatomic) UILongPressGestureRecognizer *tapAndHoldThenPanViewLongPressGestureRecognizer;


@property (weak, nonatomic) IBOutlet UIView *viewThatPansWithATransform;

@end

@implementation FirstViewController


#pragma mark - setup
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void) setup
{
    
    /* 
        UITapGestureRecognizer.
     */
    
    UITapGestureRecognizer *singleTapRecognier  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
     singleTapRecognier.numberOfTapsRequired = 1;
    
        // Gesture recognizers can only be attached to one view it seems.
//    [self.viewWithTapGestureRecognizers addGestureRecognizer: singleTapRecognier];
    
    [self.viewWithTapGestureRecognizersTExtView addGestureRecognizer: singleTapRecognier];
    
    UITapGestureRecognizer *doubleTapRecognier  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapRecognier.numberOfTapsRequired = 2;
    
    // Gesture recognizers can only be attached to one view it seems.
//    [self.viewWithTapGestureRecognizers addGestureRecognizer: doubleTapRecognier];
    
    [self.viewWithTapGestureRecognizersTExtView addGestureRecognizer: doubleTapRecognier];
    
    // Resolve single-tap and double-tap conflict.
    [singleTapRecognier requireGestureRecognizerToFail:doubleTapRecognier];
    
    self.originalTextViewColor = self.viewWithTapGestureRecognizersTExtView.backgroundColor;
    self.originalViewWithTapGestureRecognizersColor = self.viewWithTapGestureRecognizers.backgroundColor;
 
    
    /* 
        UIPanGestureRecognizer.
     */
    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByStoringOriginalCenter:)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByResettingDelta:)];
    
    [self.viewWithPanGestureRecognizer addGestureRecognizer:panGestureRecognizer];
    
    
    /* 
        UIPanGestureRecognizer with UIKitDynamics
     */
    
   UIPanGestureRecognizer *panGestureRecognizerWithUIKitDynamics = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingWithUIKitDynamics:)];
    [self.viewWithUIPanGestureRecognizerWithUIKitDynamics addGestureRecognizer:panGestureRecognizerWithUIKitDynamics];
    
    
    /* A view that can only be dragged vertically and horizontally */
    
    HorizontalPanGestureRecognizer *horizontalPanGestureRecognizer = [[HorizontalPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByResettingDelta:)];
    [self.horizontalAndVerticalDraggingView addGestureRecognizer:horizontalPanGestureRecognizer];
    
    VerticalPanGestureRecognizer *verticalPanGestureRecognizer = [[VerticalPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByResettingDelta:)];
    [self.horizontalAndVerticalDraggingView addGestureRecognizer:verticalPanGestureRecognizer];
    
    
    /* Tap and hold then pan a view */
    
    UILongPressGestureRecognizer *tapAndHoldThenPanViewLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.tapAndHoldThenPanView addGestureRecognizer: tapAndHoldThenPanViewLongPressGestureRecognizer];
    
    // Keep a reference to the UILongPressGestureRecognizer for later mediation witht the pan recognizer.
    self.tapAndHoldThenPanViewLongPressGestureRecognizer = tapAndHoldThenPanViewLongPressGestureRecognizer;
    
    
    UIPanGestureRecognizer *tapAndHoldThenPanViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByResettingDelta:)];
    [self.tapAndHoldThenPanView addGestureRecognizer: tapAndHoldThenPanViewPanGestureRecognizer];

    // Make ourself the UIPanGestureRecognizer's delegate.
    tapAndHoldThenPanViewPanGestureRecognizer.delegate = self;
    
    
    UIPanGestureRecognizer *panWithTransformPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithTransform:)];
    [self.viewThatPansWithATransform addGestureRecognizer:panWithTransformPanGestureRecognizer];
    self.viewThatPansWithATransform.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark - UIGestureRecognizerDelegate methods

// The view can only be dragged when it is pulsing.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if(self.tapAndHoldThenPanViewLongPressGestureRecognizer.state == UIGestureRecognizerStatePossible || self.tapAndHoldThenPanViewLongPressGestureRecognizer.state == UIGestureRecognizerStateFailed){
        return NO;
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


#pragma mark - UIGestureRecognizer action methods

- (void)panWithTransform:(UIPanGestureRecognizer *)recognizer
{
//    UIView *panningView = self.viewThatPansWithATransform;//recognizer.view;
//    [panningView removeConstraints:panningView.constraints];
    
    UIView *panningView = recognizer.view;
    //    [panningView removeConstraints:panningView.constraints];
    
    // Gesture ended.
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint newCenter = CGPointMake(
                                        panningView.center.x + panningView.transform.tx,
                                        panningView.center.y + panningView.transform.ty);
        panningView.center = newCenter;
    
        CGAffineTransform theTransform = panningView.transform;
        theTransform.tx = 0.0f;
        theTransform.ty = 0.0f;
        panningView.transform = theTransform;

        
        return;
    }
    
    CGPoint translation = [recognizer translationInView: panningView.superview];
    
    NSLog(@"translation = %@", NSStringFromCGPoint(translation));
    CGAffineTransform theTransform = panningView.transform;
    theTransform.tx = translation.x;
    theTransform.ty = translation.y;
    panningView.transform = theTransform;
    
    NSLog(@"transform = %@", NSStringFromCGAffineTransform(panningView.transform));
}


- (void) longPress:(UILongPressGestureRecognizer *)recognizer
{
    NSLog(@"longPress:");
    
    // Add pulsing animation.
    if(recognizer.state == UIGestureRecognizerStateBegan){
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
        anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        anim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        anim.repeatCount = HUGE_VALF;
        anim.autoreverses = YES;
        [recognizer.view.layer addAnimation:anim forKey:nil];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        [recognizer.view.layer removeAllAnimations];
    }
}


- (void) draggingWithUIKitDynamics: (UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView: self.view];
        CGPoint initialTouchLocation = [recognizer locationOfTouch:0 inView: recognizer.view];
        CGPoint center = CGPointMake(CGRectGetMidX(recognizer.view.bounds), CGRectGetMidY(recognizer.view.bounds));
        UIOffset offset = UIOffsetMake(initialTouchLocation.x - center.x, initialTouchLocation.y - center.y);
        CGPoint anchor   = [recognizer locationOfTouch:0 inView:self.view];
        
        UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.viewWithUIPanGestureRecognizerWithUIKitDynamics offsetFromCenter:offset attachedToAnchor:anchor];
        [self.dynamicAnimator addBehavior:attachmentBehavior];
        self.attachmentBehavior = attachmentBehavior;
    } else if(recognizer.state == UIGestureRecognizerStateChanged){
        self.attachmentBehavior.anchorPoint = [recognizer locationOfTouch:0 inView:self.view];
    } else{
        self.dynamicAnimator = nil;
    }
}

- (void) singleTap: (UIGestureRecognizer *)recognizer
{
    NSLog(@"\n\nsingleTap: %@", recognizer);
    NSLog(@"%lu touch(es).",(unsigned long)recognizer.numberOfTouches);
    
    self.viewWithTapGestureRecognizersTExtView.text = @"single tap in\n";
    
    self.viewWithTapGestureRecognizersTExtView.text = [self.viewWithTapGestureRecognizersTExtView.text stringByAppendingString: [recognizer.view class].description];
    
    self.viewWithTapGestureRecognizersTExtView.text = [self.viewWithTapGestureRecognizersTExtView.text stringByAppendingString: [NSString stringWithFormat:@"\nrecognizer state:%@", [self stateDescription:recognizer.state]]];
    
    // location
    self.viewWithTapGestureRecognizersTExtView.text = [self.viewWithTapGestureRecognizersTExtView.text stringByAppendingString: [NSString stringWithFormat:@"\nlocation:%@", NSStringFromCGPoint([recognizer locationInView:self.viewWithTapGestureRecognizersTExtView])]];
 
    NSUInteger options =  UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;
    [UIView animateWithDuration:0.2 delay:0 options: options  animations:^{
        self.viewWithTapGestureRecognizersTExtView.backgroundColor = [UIColor yellowColor];
        self.viewWithTapGestureRecognizers.backgroundColor = [UIColor orangeColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.viewWithTapGestureRecognizersTExtView.backgroundColor = self.originalTextViewColor;
            self.viewWithTapGestureRecognizers.backgroundColor = self.originalViewWithTapGestureRecognizersColor;
        }];
    }];

}

- (void) doubleTap: (UIGestureRecognizer *)recognizer
{
    NSLog(@"\n\ndoubleTap: %@", recognizer);
    NSLog(@"%lu touch(es).",(unsigned long)recognizer.numberOfTouches);
    self.viewWithTapGestureRecognizersTExtView.text = @"double tap\n";
    
    // view class
    self.viewWithTapGestureRecognizersTExtView.text = [self.viewWithTapGestureRecognizersTExtView.text stringByAppendingString: [recognizer.view class].description];
    
    // state
    self.viewWithTapGestureRecognizersTExtView.text = [self.viewWithTapGestureRecognizersTExtView.text stringByAppendingString: [NSString stringWithFormat:@"\nrecognizer state:%@", [self stateDescription:recognizer.state]]];
    
    // location
    self.viewWithTapGestureRecognizersTExtView.text = [self.viewWithTapGestureRecognizersTExtView.text stringByAppendingString: [NSString stringWithFormat:@"\nlocation:%@", NSStringFromCGPoint([recognizer locationInView:self.viewWithTapGestureRecognizersTExtView])]];
    
    NSUInteger options = 0;
    [UIView animateWithDuration:0.2 delay:0.5 options: options  animations:^{
        self.viewWithTapGestureRecognizersTExtView.backgroundColor = [UIColor greenColor];
        self.viewWithTapGestureRecognizers.backgroundColor = [UIColor blueColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.viewWithTapGestureRecognizersTExtView.backgroundColor = self.originalTextViewColor;
            self.viewWithTapGestureRecognizers.backgroundColor = self.originalViewWithTapGestureRecognizersColor;
        }];
    }];
    
}

- (void) draggingByStoringOriginalCenter: (UIPanGestureRecognizer *)recognizer
{
    NSLog(@"draggingByStoringOriginalCenter:");
    
    UIView *viewToDrag = recognizer.view;
    
    /*
        A UIPanGestureRecognizer maintains a delta (translation) for us. 
        This delta, available using translationInView:, is reckoned from the touch’s initial position. 
        So we need to store our center only once:
    */
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.originalViewWithPanGestureRecognizerCenter = viewToDrag.center;
    }
    CGPoint delta = [recognizer translationInView: viewToDrag.superview];
    CGPoint newCenter = self.originalViewWithPanGestureRecognizerCenter;
    newCenter.x += delta.x;
    newCenter.y += delta.y;
    viewToDrag.center = newCenter;
}

- (void) draggingByResettingDelta: (UIPanGestureRecognizer *)recognizer
{
    NSLog(@"draggingByResettingDelta:");
    
    UIView *viewToDrag = recognizer.view;
    
    /*
     A UIPanGestureRecognizer maintains a delta (translation) for us.
     This delta, available using translationInView:, is reckoned from the touch’s initial position.
     So we need to store our center only once:
     */
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint delta = [recognizer translationInView: viewToDrag.superview];
        CGPoint newCenter = viewToDrag.center;
        newCenter.x += delta.x;
        newCenter.y += delta.y;
        viewToDrag.center = newCenter;
        [recognizer setTranslation:CGPointZero inView: viewToDrag.superview];
    }
}


#pragma mark - utility methods
- (NSString *)stateDescription: (UIGestureRecognizerState)state
{

    NSString *stateString = @"";
    switch (state) {
        case UIGestureRecognizerStatePossible:
            stateString = @"possible";
            break;
        case UIGestureRecognizerStateBegan:
            stateString = @"began";
            break;
        case UIGestureRecognizerStateChanged:
            stateString = @"changed";
            break;
        case UIGestureRecognizerStateEnded:
            stateString = @"ended";
            break;
        case UIGestureRecognizerStateCancelled:
            stateString = @"cancelled";
            break;
        default:
            stateString = @"recognized";
            break;
    }
    return stateString;
}

@end
