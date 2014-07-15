//
//  HitTestingViewController.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace [DATACOM] on 15/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "HitTestingViewController.h"


@interface HitTestingViewController ()

@property (weak, nonatomic) IBOutlet UIView *hitTestView;
@property (weak, nonatomic) IBOutlet UIView *tapOutsideBoundsView;

@property (weak, nonatomic) IBOutlet UIView *layerHitTestView;
@property (weak, nonatomic)CALayer *redRectLayer;
@property (weak, nonatomic)CALayer *greenRectLayer;

@end

@implementation HitTestingViewController

- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    NSLog(@"tap:");
    
    CGPoint tapPoint = [sender locationOfTouch:0 inView:self.hitTestView];
    UIView *tappedView =[self.hitTestView hitTest:tapPoint withEvent:nil];
    
    if([tappedView isKindOfClass:[UIImageView class]]){
        [self swellBriefly: tappedView];
    }
}

- (IBAction)tapLayers:(UITapGestureRecognizer *)sender
{
    NSLog(@"tapLayers:");
    
    CGPoint tapPoint = [sender locationOfTouch:0 inView: sender.view];
    NSLog(@"tap at %@ in view.", NSStringFromCGPoint(tapPoint));
    
    NSLog(@"layer frame = %@", NSStringFromCGRect(sender.view.layer.frame));
    
    CALayer *result = [sender.view.layer hitTest:tapPoint];
    
    NSLog(@"result = %@",result);
    
    if (result == self.redRectLayer || result == self.greenRectLayer) {
        NSString *layerDesc = @"Missed";
        if(result == self.redRectLayer){
            layerDesc = @"red";
        }
        if(result == self.greenRectLayer){
            layerDesc = @"green";
        }
        NSLog(@"a hit at %@ on %@", NSStringFromCGPoint(tapPoint), layerDesc );
//        [self colorBriefly:result withColor:[UIColor brownColor]];
    }
//    }
    
//    for (CALayer *subLayer in [sender.view.layer.sublayers reverseObjectEnumerator]) {
//        NSLog(@"subLayer frame = %@", NSStringFromCGRect(subLayer.frame));
//
//        CGPoint pt = [subLayer convertPoint:tapPoint fromLayer:sender.view.layer];
//        
//        NSLog(@"tap at %@", NSStringFromCGPoint(pt));
//        CALayer *result = [subLayer hitTest:pt];
//        if (result == self.redRectLayer || result == self.greenRectLayer ) {
//            NSLog(@"a hit at %@ on %@", NSStringFromCGPoint(pt), result == self.redRectLayer?@"red":@"missed red" );
//            [self colorBriefly:result withColor:[UIColor brownColor]];
////            break;
//        }
//    }
}

-(void)swellBriefly:(UIView *)view
{
    CGRect originalBounds = view.bounds;
    [UIView animateWithDuration:0.25
                          delay: 0
                        options: 0//UIViewAnimationOptionAutoreverse
                     animations:^{
                         CGRect newbounds = view.bounds;
                         newbounds.size.width += 10;
                         newbounds.size.height += 10;
                         view.bounds = newbounds;
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25
                                          animations:^{
                                              view.bounds = originalBounds;
                                          }];
                     }];
}

-(void)colorBriefly:(CALayer *)layer withColor: (UIColor *)color
{
    CGColorRef originalColor = layer.backgroundColor;
    [UIView animateWithDuration:0.25
                          delay: 0
                        options: 0//UIViewAnimationOptionAutoreverse
                     animations:^{
                         layer.backgroundColor = color.CGColor;
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25
                                          animations:^{
                                              layer.backgroundColor = originalColor;
                                          }];
                     }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tapOutsideBoundsView.clipsToBounds = NO;
    
    
    CALayer *redRectLayer = [[CALayer alloc] init];
    redRectLayer.bounds = CGRectMake(0, 0, 100, 100);
    redRectLayer.position = CGPointMake(100, 100);
    redRectLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layerHitTestView.layer addSublayer:redRectLayer];
    self.redRectLayer = redRectLayer;
    
    CALayer *greenRectLayer = [[CALayer alloc] init];
    greenRectLayer.bounds = CGRectMake(0, 0, 100, 100);
    greenRectLayer.position = CGPointMake(300, 100);
    greenRectLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.layerHitTestView.layer addSublayer:greenRectLayer];
    self.greenRectLayer = greenRectLayer;
    
}


@end
