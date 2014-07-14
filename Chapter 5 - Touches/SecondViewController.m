//
//  SecondViewController.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "SecondViewController.h"
#import "RotateScaleAndTranslateView.h"
#import "DrawingView.h"

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
    
    DrawingView *drawingView = [[DrawingView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 200.0f)]; //[UIScreen mainScreen].applicationFrame];
    [self.view addSubview: drawingView];
    
    
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    drawingView.backgroundColor = [UIColor orangeColor];
    
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
