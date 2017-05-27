//
//  ACTemplateCVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 03/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateCVC.h"

#import "NSNotificationCenter+AppCore.h"
#import "UIViewController+AppCore.h"

#import "ACDesignHelper.h"
#import "ACLocalizationHelper.h"

@implementation ACTemplateCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ac_initBackButtonIfNeeded];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(ac_didUpdatedDesign) name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(ac_didUpdatedLocalization) name:ACUpdateLocalization];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateLocalization];
}

#pragma mark - ACUpdaterVCProtocol
- (void)ac_didUpdatedDesign {
    [self.collectionView reloadData];
}

- (void)ac_didUpdatedLocalization {
    [self.collectionView reloadData];
}

@end
