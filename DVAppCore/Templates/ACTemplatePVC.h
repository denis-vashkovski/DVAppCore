//
//  ACTemplatePVC.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 03/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateVC.h"

@interface ACTemplatePageVC : ACTemplateVC
@property (nonatomic) NSInteger index;
@end

@protocol ACTemplatePVCDelegate;

@interface ACTemplatePVC : ACTemplateVC
@property (nonatomic, strong, readonly) UIPageViewController *pageViewController;
@property (nonatomic, weak) id<ACTemplatePVCDelegate> ac_delegate;
@end

@protocol ACTemplatePVCDelegate <NSObject>
@required
- (NSInteger)ac_numberOfPagesInTemplatePVC:(ACTemplatePVC *)templatePVC;
- (ACTemplatePageVC *)ac_templatePVC:(ACTemplatePVC *)templatePVC viewControllerForPage:(NSInteger)page;

@optional
- (void)ac_templatePVC:(ACTemplatePVC *)templatePVC pageDidAppear:(ACTemplatePageVC *)pageVC;
@end

#define INFINITE_NUMBER_OF_PAGES NSIntegerMax
