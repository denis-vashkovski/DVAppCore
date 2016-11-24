//
//  ACTemplateAppDelegate.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACTemplateAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *windowForAlerts;

- (UIInterfaceOrientationMask)ac_interfaceOrientationsDefault;
- (void)ac_addInterfaceOrientations:(UIInterfaceOrientationMask)interfaceOrientations forVC:(Class)vc;
@end
