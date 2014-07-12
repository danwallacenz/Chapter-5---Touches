//
//  FirstViewController.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "FirstViewController.h"
#import "DraggableView.h"

@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet DraggableView *draggableView;

@property (weak, nonatomic) IBOutlet UIView *viewWithTapGestureRecognizers;
@property (weak, nonatomic) IBOutlet UITextView *viewWithTapGestureRecognizersTExtView;

@property (strong, nonatomic) UIColor *originalTextViewColor;
@property (strong, nonatomic) UIColor *originalViewWithTapGestureRecognizersColor;

@property (weak, nonatomic) IBOutlet UIView *viewWithPanGestureRecognizer;
@property CGPoint originalViewWithPanGestureRecognizerCenter;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void) setup
{
    
    /* UITapGestureRecognizer. */
    
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
    
    self.originalTextViewColor = self.viewWithTapGestureRecognizersTExtView.backgroundColor;
    self.originalViewWithTapGestureRecognizersColor = self.viewWithTapGestureRecognizers.backgroundColor;
 
    
    /* UITapGestureRecognizer. */
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByStoringOriginalCenter:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingByResettingDelta:)];
    [self.viewWithPanGestureRecognizer addGestureRecognizer:panGestureRecognizer];
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
