//
//  DraggableView.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "DraggableView.h"

@implementation DraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    [self logTouches:touches];
    [self logEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesMoved");
    
    [self logTouches:touches];
    [self logEvent:event];
    
    [self.superview bringSubviewToFront:self];
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: self.superview];
    CGPoint lastTouchLocation = [touch previousLocationInView: self.superview];
    CGFloat deltaX = touchLocation.x - lastTouchLocation.x;
    CGFloat deltaY = touchLocation.y - lastTouchLocation.y;
    CGPoint newCenter = self.center;
    newCenter.x += deltaX;
    newCenter.y += deltaY;
    self.center = newCenter;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded");
    
    [self logTouches:touches];
    [self logEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesCancelled");
    
    [self logTouches:touches];
    [self logEvent:event];
}

- (void) logTouches: (NSSet *)touches
{
//    NSLog(@"touches: %@", touches);
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self];
        CGPoint superviewLocation = [touch locationInView:self.superview];
        NSTimeInterval timestamp =  touch.timestamp;
        NSUInteger tapCount = touch.tapCount;
        UIView *tappedView = touch.view;
        UITouchPhase phase = touch.phase;
        
        NSString *touchPhaseDescription = @"unknown phase";
        switch (phase) {
            case UITouchPhaseBegan:
                touchPhaseDescription = @"UITouchPhaseBegan";
                break;
            case UITouchPhaseMoved:
                touchPhaseDescription = @"UITouchPhaseMoved";
                break;
            case UITouchPhaseStationary:
                touchPhaseDescription = @"UITouchPhaseStationary";
                break;
            case UITouchPhaseEnded:
                touchPhaseDescription = @"UITouchPhaseEnded";
                break;
            case UITouchPhaseCancelled:
                touchPhaseDescription = @"UITouchPhaseCancelled";
                break;
            default:
                break;
        }
        
        NSLog(@"\n\ntouch - phase: %@ \nlocation in draggable view: %@ \nsuperview location: %@ \ntimestamp:%f \ntapCount: %lu \ntapped view: %@\n\n", touchPhaseDescription, NSStringFromCGPoint(location), NSStringFromCGPoint(superviewLocation), timestamp, (unsigned long)tapCount, [tappedView class]);
    }
}

- (void) logEvent: (UIEvent *)event
{
//    NSLog(@"event: %@", event);
}

@end
