//
//  UICollectionViewController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 26/04/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import "UICollectionViewController+AppCore.h"

#import "ACDesignHelper.h"

@implementation UICollectionViewController(AppCore)

#pragma mark - ACRefreshProtocol
- (void)ac_initRefreshView {
    self.collectionView.refreshControl = [UIRefreshControl new];
    [self.collectionView.refreshControl setTintColor:ACDesign(ACDesignColorRefreshControlTVC)];
    [self.collectionView.refreshControl addTarget:self action:@selector(ac_refreshView) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl.layer.zPosition = self.collectionView.backgroundView.layer.zPosition + 1;
}

- (void)ac_startRefreshing {
    if (!self.collectionView.refreshControl || (self.collectionView.contentOffset.y > .0)) return;
    
    [self.collectionView setContentOffset:CGPointMake(.0,
                                                      (self.collectionView.contentOffset.y - CGRectGetHeight(self.collectionView.refreshControl.frame)))
                                 animated:YES];
    [self.collectionView.refreshControl beginRefreshing];
}

- (void)ac_endRefreshing {
    if (!self.collectionView.refreshControl) return;
    
    [self.collectionView.refreshControl endRefreshing];
}

- (void)ac_refreshView {
    [self ac_endRefreshing];
}

@end
