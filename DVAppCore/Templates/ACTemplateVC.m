//
//  ACTemplateVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateVC.h"

#import "NSNotificationCenter+AppCore.h"

#import "ACDesignHelper.h"
#import "ACLocalizationHelper.h"

@implementation ACTemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(didUpdatedDesign) name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(didUpdatedLocalization) name:ACUpdateLocalization];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateLocalization];
}

#pragma mark - ACUpdaterVCProtocol
- (void)didUpdatedDesign {
    
}

- (void)didUpdatedLocalization {
    
}

@end
