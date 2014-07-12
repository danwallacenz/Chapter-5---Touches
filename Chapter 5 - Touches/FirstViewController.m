//
//  FirstViewController.m
//  Chapter 5 - Touches
//
//  Created by Daniel Wallace on 11/07/14.
//  Copyright (c) 2014 nz.co.danielw. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewWithTapGestureRecognizers;
@property (weak, nonatomic) IBOutlet UITextView *viewWithTapGestureRecognizersTExtView;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void) setup
{
    UITapGestureRecognizer *singleTapRecognier  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
     singleTapRecognier.numberOfTapsRequired = 1;
    [self.viewWithTapGestureRecognizers addGestureRecognizer: singleTapRecognier];
    [self.viewWithTapGestureRecognizersTExtView addGestureRecognizer: singleTapRecognier];
    
    UITapGestureRecognizer *doubleTapRecognier  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapRecognier.numberOfTapsRequired = 2;
    [self.viewWithTapGestureRecognizers addGestureRecognizer: doubleTapRecognier];
    [self.viewWithTapGestureRecognizersTExtView addGestureRecognizer: doubleTapRecognier];
}

- (void) singleTap: (UIGestureRecognizer *)recognizer
{
    NSLog(@"\n\nsingleTap: %@", recognizer);
    NSLog(@"%lu touch(es).",(unsigned long)recognizer.numberOfTouches);
    
    self.viewWithTapGestureRecognizersTExtView.text = @"single tap";
    [self.viewWithTapGestureRecognizersTExtView setNeedsDisplay];
}

- (void) doubleTap: (UIGestureRecognizer *)recognizer
{
    NSLog(@"\n\ndoubleTap: %@", recognizer);
    NSLog(@"%lu touch(es).",(unsigned long)recognizer.numberOfTouches);
    self.viewWithTapGestureRecognizersTExtView.text = @"double tap";
    [self.viewWithTapGestureRecognizersTExtView setNeedsDisplay];
}

@end
