//
//  SecondViewController.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "SecondViewController.h"
#import "RotateScaleAndTranslateView.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    RotateScaleAndTranslateView *rotateScaleAndTranslateView  = [[RotateScaleAndTranslateView alloc] initWithImage:[UIImage imageNamed: @"sun.png"]];
    [self.view addSubview:rotateScaleAndTranslateView];
    rotateScaleAndTranslateView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
