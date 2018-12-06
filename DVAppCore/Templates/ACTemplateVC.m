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
    
    [self ac_initBackButtonIfNeeded];
    
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(ac_didUpdatedDesign) name:ACUpdateDesign];
    [[NSNotificationCenter defaultCenter] ac_addObserver:self selector:@selector(ac_didUpdatedLocalization) name:ACUpdateLocalization];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self ac_hideKeyboard];
    
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self
                                                       name:UIKeyboardWillShowNotification];
    
    [[NSNotificationCenter defaultCenter] ac_removeObserver:self
                                                       name:UIKeyboardWillHideNotification];
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


#pragma mark - ACUpdaterVCProtocol
- (void)ac_didUpdatedDesign {
    
}

- (void)ac_didUpdatedLocalization {
    
}

@end
