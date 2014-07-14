//
//  HorizontalPanGestureRecognizer.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 13/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "HorizontalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface HorizontalPanGestureRecognizer ()

@property CGPoint firstTouchLocation;

@end

@implementation HorizontalPanGestureRecognizer


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.firstTouchLocation = [(UITouch *)touches.anyObject locationInView: self.view.superview];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.state == UIGestureRecognizerStatePossible){
        CGPoint touchLocation = [(UITouch *)touches.anyObject locationInView: self.view.superview];
        CGFloat deltaX = fabs(touchLocation.x - self.firstTouchLocation.x);
        CGFloat deltaY = fabs(touchLocation.y - self.firstTouchLocation.y);
        
        if(deltaY >= deltaX){
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    [super touchesMoved:touches withEvent:event];
}

-(CGPoint)translationInView:(UIView *)view
{
    CGPoint proposedTranslation = [super translationInView:view];

    // Prevent vertical pan.
    proposedTranslation.y = 0;
    
    // Prevent pan beyond right margin of superview.
    if([self willPanBeyondSuperviewRightSideWithTranslation:proposedTranslation]){
        proposedTranslation.x = [self calculateMaxXTranslationForTranslation:proposedTranslation inView:self.view];
    }
    
    // Prevent pan beyond right margin of superview.
   if([self willPanBeyondSuperviewLeftSideWithTranslation:proposedTranslation]){
        proposedTranslation.x = [self calculateMinXTranslationForTranslation:proposedTranslation inView:self.view];
    }
    
    return proposedTranslation;
}


#pragma mark - utilities

- (CGFloat) calculateMinXTranslationForTranslation: (CGPoint)translation inView: (UIView *)view
{
    CGFloat minXTranslation = [self leftSideLocationOfView: view.superview] - [self leftSideLocationOfView:view];
    return minXTranslation;
}

- (CGFloat) calculateMaxXTranslationForTranslation: (CGPoint)translation inView: (UIView *)view
{
    CGFloat maxXTranslation = [self rightSideLocationOfView:view.superview] - [self rightSideLocationOfView:view];
    return maxXTranslation;
}

-(BOOL)willPanBeyondSuperviewLeftSideWithTranslation: (CGPoint)translation
{
    CGFloat translationX = [self leftSideLocationOfView: self.view] + translation.x;
    return translationX < self.view.superview.frame.origin.x;
}

-(BOOL)willPanBeyondSuperviewRightSideWithTranslation: (CGPoint)translation
{
    CGFloat translationX = [self rightSideLocationOfView: self.view] + translation.x;
    return translationX > self.view.superview.bounds.size.width;
}

- (CGFloat)rightSideLocationOfView: (UIView *)view
{
    return view.center.x + CGRectGetMidX(view.bounds);
}

- (CGFloat)leftSideLocationOfView: (UIView *)view
{
    return view.center.x - CGRectGetMidX(view.bounds);
}

@end
