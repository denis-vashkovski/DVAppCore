//
//  TestCVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 26/04/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import "TestCVC.h"

#import "UIViewController+AppCore.h"
#import "UICollectionViewController+AppCore.h"
#import "UIColor+AppCore.h"
#import "UINavigationController+AppCore.h"

#import "ACRouter.h"

#import "ViewController.h"

@interface TestCVC ()

@end

@implementation TestCVC

+ (instancetype)ac_newInstance {
    return (TestCVC *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView setBackgroundColor:[UIColor ac_randomColor]];
    
    [self ac_initRefreshView];
}

- (void)ac_refreshView {
    [self.collectionView setBackgroundColor:[UIColor ac_randomColor]];
    [self ac_endRefreshing];
}

- (void)ac_onBackButtonTouch:(UIBarButtonItem *)sender {
    [self.navigationController ac_popToRootViewControllerAnimationType:ACAnimationTransitionCurlDown];
}

@end
