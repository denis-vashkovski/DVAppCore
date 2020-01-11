//
//  ACTemplateVC.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UIViewController+AppCore.h"

#import "ACUpdaterVCProtocol.h"

@protocol ACTemplateVCKeyboardDelegate <NSObject>
@optional
- (void)keyboardWillShownWithSize:(CGSize)size;
- (void)keyboardWillBeHidden;
- (void)keyboardDidBeHidden;
@end

@interface ACTemplateVC : UIViewController<ACUpdaterVCProtocol, ACTemplateVCKeyboardDelegate>
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, readonly, getter=isViewAppearNotFirstTime) BOOL viewAppearNotFirstTime;
@end
