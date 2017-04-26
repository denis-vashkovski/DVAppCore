//
//  TestCVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 26/04/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import "TestCVC.h"

#import "UICollectionViewController+AppCore.h"
#import "UIColor+AppCore.h"

#import "ACRouter.h"

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

@end
