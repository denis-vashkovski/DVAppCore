//
//  ACTemplateTBC.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACTemplateTBCDataSource;

@interface ACTemplateTBC : UITabBarController
@property (nonatomic, weak) id<ACTemplateTBCDataSource> ac_dataSource;

- (void)ac_reloadTabs;
@end

@protocol ACTemplateTBCDataSource <NSObject>
- (NSArray<UIViewController *> *)ac_viewControllersForTabs;
- (NSArray<NSString *> *)ac_titlesForTabs;
- (NSArray<UIImage *> *)ac_imagesForTabs;

@optional
- (NSArray<UIImage *> *)ac_selectedImagesForTabs;
@end
