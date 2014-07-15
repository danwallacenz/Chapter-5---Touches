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
    CGPoint tapPoint = [sender locationOfTouch:0 inView:self.hitTestView];
    UIView *tappedView =[self.hitTestView hitTest:tapPoint withEvent:nil];
    
    if([tappedView isKindOfClass:[UIImageView class]]){
        [self swellBriefly: tappedView];
    }
}

- (IBAction)tapLayers:(UITapGestureRecognizer *)sender
{
    CGPoint tapPoint = [sender locationOfTouch:0 inView: sender.view];
    CGPoint tapPointInLayer = [sender.view.layer convertPoint:tapPoint toLayer:sender.view.layer.superlayer];
    CALayer *hitLayer = [sender.view.layer hitTest: tapPointInLayer];

    if (hitLayer == self.redRectLayer || hitLayer == self.greenRectLayer) {
        
        [self colorBriefly: hitLayer withColor:[UIColor orangeColor]];
        
//        NSString *layerDesc = @" but missed";
//        if(hitLayer == self.redRectLayer){
//            layerDesc = @"red.";
//        }
//        if(hitLayer == self.greenRectLayer){
//            layerDesc = @"green.";
//        }
//        NSLog(@"a hit at %@ on %@", NSStringFromCGPoint(tapPoint), layerDesc);

    }
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
    UIColor *originalColor = [UIColor colorWithCGColor:layer.backgroundColor];
    
    [CATransaction setCompletionBlock:^{
        layer.backgroundColor = originalColor.CGColor;
    }];
    
    layer.backgroundColor = color.CGColor;

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
