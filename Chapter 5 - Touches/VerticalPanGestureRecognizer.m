//
//  HorizontalPanGestureRecognizer.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 13/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "VerticalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface VerticalPanGestureRecognizer ()

@property CGPoint firstTouchLocation;

@end

@implementation VerticalPanGestureRecognizer


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
        if(deltaX >= deltaY){
            self.state = UIGestureRecognizerStateFailed;
        }
    }
    
    [super touchesMoved:touches withEvent:event];
}

-(CGPoint)translationInView:(UIView *)view
{
    CGPoint proposedTranslation = [super translationInView:view];
    proposedTranslation.x = 0;
    return proposedTranslation;
}

@end
