//
//  DraggableView.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()

@property (strong, nonatomic) UILabel *positionInSelfLabel;
@property (strong, nonatomic) UILabel *positionInSuperviewLabel;

@end

@implementation DraggableView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.positionInSelfLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20.0f)];
    [self addSubview:self.positionInSelfLabel];
    
    self.positionInSuperviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.0f, self.bounds.size.width, 20.0f)];
    [self addSubview:self.positionInSuperviewLabel];
    
    self.positionInSelfLabel.text =  NSStringFromCGPoint(CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)));
    self.positionInSuperviewLabel.text =   NSStringFromCGPoint(self.center); 
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
                touchPhaseDescription = @"Began";
                break;
            case UITouchPhaseMoved:
                touchPhaseDescription = @"Moved";
                break;
            case UITouchPhaseStationary:
                touchPhaseDescription = @"Stationary";
                break;
            case UITouchPhaseEnded:
                touchPhaseDescription = @"Ended";
                break;
            case UITouchPhaseCancelled:
                touchPhaseDescription = @"Cancelled";
                break;
            default:
                break;
        }
        
        NSLog(@"\n\ntouch - phase: %@ \nlocation in draggable view: %@ \nsuperview location: %@ \ntimestamp:%f \ntapCount: %lu \ntapped view: %@\n\n", touchPhaseDescription, NSStringFromCGPoint(location), NSStringFromCGPoint(superviewLocation), timestamp, (unsigned long)tapCount, [tappedView class]);
        
        self.positionInSelfLabel.text =  NSStringFromCGPoint(location);
        self.positionInSuperviewLabel.text =  NSStringFromCGPoint(superviewLocation);
    }
}

- (void) logEvent: (UIEvent *)event
{
    NSLog(@"\nevent - count:%lu\n", (unsigned long)[event touchesForView:self].count);
}

@end
