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


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
