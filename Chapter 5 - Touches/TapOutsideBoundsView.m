//
//  TapOutsideBoundsView.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace [DATACOM] on 15/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "TapOutsideBoundsView.h"

@implementation TapOutsideBoundsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    if(result){
        [self colorBriefly:result withColor: [UIColor redColor]];
        return result;
    }
    for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
        CGPoint p = [self convertPoint:point toView:subView];
        result = [subView hitTest:p withEvent:event];
        if (result)  {
            [self colorBriefly:result withColor: [UIColor greenColor] ];
            return result;
        }
    }
    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    NSLog(@"inside? %@", inside?@"YES":@"NO");
    
    return inside;
}

-(void)colorBriefly:(UIView *)view withColor: (UIColor *)color
{
    UIColor *originalColor = view.backgroundColor;
    [UIView animateWithDuration:0.25
                          delay: 0
                        options: 0//UIViewAnimationOptionAutoreverse
                     animations:^{
                         view.backgroundColor = color;
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25
                                          animations:^{
                                              view.backgroundColor = originalColor;
                                          }];
                     }];
}

@end
