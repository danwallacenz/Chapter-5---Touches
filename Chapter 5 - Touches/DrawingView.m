//
//  DrawingView.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 14/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

{
    UIBezierPath *path;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		self.multipleTouchEnabled = NO;
	}
	return self;
}

- (void)clear
{
    path = nil;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	path = [UIBezierPath bezierPath];
	path.lineWidth = 8.0f; //IS_IPAD? 8.0f : 4.0f;
	
	UITouch *touch = [touches anyObject];
	[path moveToPoint:[touch locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	[path addLineToPoint:[touch locationInView:self]];
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	[path addLineToPoint:[touch locationInView:self]];
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
	[[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f] set];
	[path stroke];
}

@end
