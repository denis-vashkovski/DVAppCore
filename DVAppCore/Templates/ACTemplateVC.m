//
//  ACTemplateVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateVC.h"

#import "NSNotificationCenter+AppCore.h"

#import "UINavigationController+AppCore.h"

#import "ACDesignHelper.h"
#import "ACLocalizationHelper.h"
#import "ACKeyboardListener.h"

@interface ACTemplateVC()<UIGestureRecognizerDelegate>

@end

@implementation ACTemplateVC

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self name:ACUpdateLocalization];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self
                                                selector:@selector(ac_private_keyboardWillShown:)
                                                    name:UIKeyboardWillShowNotification];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self
                                                selector:@selector(ac_private_keyboardWillBeHidden:)
                                                    name:UIKeyboardWillHideNotification];
    
    _visible = YES;
    _viewAppearNotFirstTime = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController ac_updateInteractivePopGestureRecognizerDelegateIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self ac_hideKeyboard];
    
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self
                                                       name:UIKeyboardWillShowNotification];
    
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self
                                                       name:UIKeyboardWillHideNotification];
    
    _visible = NO;
}

#pragma mark - Keyboard delegate
- (void)ac_private_keyboardWillShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if ([self respondsToSelector:@selector(keyboardWillShownWithSize:)]) {
        [self keyboardWillShownWithSize:keyboardSize];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)ac_private_keyboardWillBeHidden:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    if ([self respondsToSelector:@selector(keyboardWillBeHidden)]) {
        [self keyboardWillBeHidden];
    }
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ([self respondsToSelector:@selector(keyboardDidBeHidden)]) {
            [self keyboardDidBeHidden];
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (![ACKeyboardListener sharedKeyboardListener].isVisible || ![touch.view isKindOfClass:[UIControl class]]);
}

#pragma mark - ACUpdaterVCProtocol
- (void)ac_didUpdatedDesign {
    
}

- (void)ac_didUpdatedLocalization {
    
}

@end
