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
@property (nonatomic, weak) id <ACTemplateTBCDataSource> dataSource;

- (void)reloadTabs;
@end

@protocol ACTemplateTBCDataSource <NSObject>
- (NSArray<UIViewController *> *)viewControllersForTabs;
- (NSArray<NSString *> *)titlesForTabs;
- (NSArray<UIImage *> *)imagesForTabs;

@optional
- (NSArray<UIImage *> *)selectedImagesForTabs;
@end
