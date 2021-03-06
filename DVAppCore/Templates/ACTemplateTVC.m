//
//  ACTemplateTVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateTVC.h"

#import "NSNotificationCenter+AppCore.h"

#import "UINavigationController+AppCore.h"
#import "UIViewController+AppCore.h"

#import "ACDesignHelper.h"
#import "ACLocalizationHelper.h"
#import "ACKeyboardListener.h"

@interface ACTemplateTVC()<UIGestureRecognizerDelegate>

@end

@implementation ACTemplateTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(ac_didUpdatedDesign) name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(ac_didUpdatedLocalization) name:ACUpdateLocalization];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(ac_hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [gestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _visible = YES;
    _viewAppearNotFirstTime = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController ac_updateInteractivePopGestureRecognizerDelegateIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _visible = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateLocalization];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (![ACKeyboardListener sharedKeyboardListener].isVisible || ![touch.view isKindOfClass:[UIControl class]]);
}

#pragma mark - ACUpdaterVCProtocol
- (void)ac_didUpdatedDesign {
    [self.tableView reloadData];
}

- (void)ac_didUpdatedLocalization {
    [self.tableView reloadData];
}

@end
