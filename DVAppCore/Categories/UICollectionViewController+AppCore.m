//
//  UICollectionViewController+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 26/04/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

#import "UICollectionViewController+AppCore.h"

#import "ACDesignHelper.h"
#import "NSObject+AppCore.h"
#import "ACConstants.h"

@implementation UICollectionViewController(AppCore)

AC_CATEGORY_PROPERTY_GET(UIRefreshControl *, ac_refreshControl)
AC_CATEGORY_PROPERTY_SET(UIRefreshControl *, ac_refreshControl, setACRefreshControl:)

#pragma mark - ACRefreshProtocol
- (void)ac_initRefreshView {
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
        self.collectionView.refreshControl = [UIRefreshControl new];
        [self.collectionView.refreshControl setTintColor:ACDesign(ACDesignColorRefreshControlTVC)];
        [self.collectionView.refreshControl addTarget:self action:@selector(ac_refreshView) forControlEvents:UIControlEventValueChanged];
        self.collectionView.refreshControl.layer.zPosition = self.collectionView.backgroundView.layer.zPosition + 1;
    } else {
        if (self.ac_refreshControl) {
            [self.ac_refreshControl removeFromSuperview];
        }
        
        [self setACRefreshControl:[UIRefreshControl new]];
        self.ac_refreshControl.tintColor = ACDesign(ACDesignColorRefreshControlTVC);
        [self.ac_refreshControl addTarget:self action:@selector(ac_refreshView) forControlEvents:UIControlEventValueChanged];
        [self.collectionView addSubview:self.ac_refreshControl];
    }
}

- (void)ac_startRefreshing {
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
        if (!self.collectionView.refreshControl || (self.collectionView.contentOffset.y > .0)) return;
        
        [self.collectionView setContentOffset:CGPointMake(.0, (self.collectionView.contentOffset.y - CGRectGetHeight(self.collectionView.refreshControl.frame)))
                                     animated:YES];
        [self.collectionView.refreshControl beginRefreshing];
    } else {
        if (!self.ac_refreshControl || (self.collectionView.contentOffset.y > .0)) return;
        
        [self.collectionView setContentOffset:CGPointMake(.0, (self.collectionView.contentOffset.y - CGRectGetHeight(self.ac_refreshControl.frame)))
                                     animated:YES];
        [self.ac_refreshControl beginRefreshing];
    }
}

- (void)ac_endRefreshing {
    if (AC_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
        if (!self.collectionView.refreshControl) return;
        [self.collectionView.refreshControl endRefreshing];
    } else {
        if (!self.ac_refreshControl) return;
        [self.ac_refreshControl endRefreshing];
    }
}

- (void)ac_refreshView {
    [self ac_endRefreshing];
}

@end
