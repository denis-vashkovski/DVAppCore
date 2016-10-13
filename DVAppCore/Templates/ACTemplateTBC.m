//
//  ACTemplateTBC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateTBC.h"

#import "NSArray+AppCore.h"

@implementation ACTemplateTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadTabs];
}

- (void)reloadTabs {
    NSArray<UIViewController *> *viewControllers = nil;
    if (!self.dataSource
        || ![self.dataSource respondsToSelector:@selector(viewControllersForTabs)]
        || !(viewControllers = [self.dataSource viewControllersForTabs])
        || !ValidArray(viewControllers)) {
        return;
    }
    
    [self setViewControllers:viewControllers];
    
    NSUInteger numberTabs = self.viewControllers.count;
    
    NSArray<NSString *> *titles = nil;
    NSArray<UIImage *> *images = nil;
    NSArray<UIImage *> *selectedImages = nil;
    
    if ([self.dataSource respondsToSelector:@selector(titlesForTabs)]) {
        titles = [self.dataSource titlesForTabs];
        NSAssert((titles.count == numberTabs), @"Number titles and number tabs not equal");
    }
    if ([self.dataSource respondsToSelector:@selector(imagesForTabs)]) {
        images = [self.dataSource imagesForTabs];
        NSAssert((images.count == numberTabs), @"Number images and number tabs not equal");
    }
    if ([self.dataSource respondsToSelector:@selector(selectedImagesForTabs)]) {
        selectedImages = [self.dataSource selectedImagesForTabs];
        NSAssert((selectedImages.count == numberTabs), @"Number selected images and number tabs not equal");
    }
    
    for (int indexTab = 0; indexTab < numberTabs; indexTab++) {
        UIViewController *vc = [self.viewControllers objectAtIndex:indexTab];
        
        if (ValidArray(titles)) {
            [vc.tabBarItem setTitle:[titles objectAtIndex:indexTab]];
        }
        if (ValidArray(images)) {
            [vc.tabBarItem setImage:[[images objectAtIndex:indexTab] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
        if (ValidArray(selectedImages)) {
            [vc.tabBarItem setSelectedImage:[[selectedImages objectAtIndex:indexTab] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    }
}

@end
