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
    [self ac_reloadTabs];
}

- (void)ac_reloadTabs {
    NSArray<UIViewController *> *viewControllers = nil;
    if (!self.ac_dataSource
        || ![self.ac_dataSource respondsToSelector:@selector(ac_viewControllersForTabs)]
        || !(viewControllers = [self.ac_dataSource ac_viewControllersForTabs])
        || !ACValidArray(viewControllers)) {
        return;
    }
    
    [self setViewControllers:viewControllers];
    
    NSUInteger numberTabs = self.viewControllers.count;
    
    NSArray<NSString *> *titles = nil;
    NSArray<UIImage *> *images = nil;
    NSArray<UIImage *> *selectedImages = nil;
    
    if ([self.ac_dataSource respondsToSelector:@selector(ac_titlesForTabs)]) {
        titles = [self.ac_dataSource ac_titlesForTabs];
        NSAssert((titles.count == numberTabs), @"Number titles and number tabs not equal");
    }
    if ([self.ac_dataSource respondsToSelector:@selector(ac_imagesForTabs)]) {
        images = [self.ac_dataSource ac_imagesForTabs];
        NSAssert((images.count == numberTabs), @"Number images and number tabs not equal");
    }
    if ([self.ac_dataSource respondsToSelector:@selector(ac_selectedImagesForTabs)]) {
        selectedImages = [self.ac_dataSource ac_selectedImagesForTabs];
        NSAssert((selectedImages.count == numberTabs), @"Number selected images and number tabs not equal");
    }
    
    for (int indexTab = 0; indexTab < numberTabs; indexTab++) {
        UIViewController *vc = [self.viewControllers objectAtIndex:indexTab];
        
        if (ACValidArray(titles)) {
            [vc.tabBarItem setTitle:[titles objectAtIndex:indexTab]];
        }
        if (ACValidArray(images)) {
            [vc.tabBarItem setImage:[[images objectAtIndex:indexTab] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
        if (ACValidArray(selectedImages)) {
            [vc.tabBarItem setSelectedImage:[[selectedImages objectAtIndex:indexTab] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        }
    }
}

@end
