//
//  ViewController.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ViewController.h"

#import "UIView+AppCore.h"
#import "UIBarButtonItem+AppCore.h"
#import "UINavigationController+AppCore.h"

#import "TestTVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.view viewWithTag:1] setAc_shapeType:ACShapeTypeCircle];
}

- (IBAction)onRightBarButtonTouch:(id)sender {
    NSLog(@"!!!!!!!!!!");
}

- (IBAction)onButtonNextTouch:(id)sender {
    [self.navigationController ac_pushViewController:[TestTVC newInstance]
                                       animationType:ACAnimationTransitionFlipFromTop
                                   animationDuration:.5
                                   completionHandler:nil];
}

@end
