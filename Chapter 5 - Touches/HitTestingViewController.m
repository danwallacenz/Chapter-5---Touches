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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
