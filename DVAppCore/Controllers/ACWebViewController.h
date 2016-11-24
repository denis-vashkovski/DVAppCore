//
//  ACWebViewController.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateVC.h"

@interface ACWebViewController : ACTemplateVC
+ (instancetype)openUrl:(NSURL *)url withPresentingVC:(UIViewController *)presentingVC;
+ (instancetype)openUrl:(NSURL *)url withPushingNVC:(UINavigationController *)pushingNVC;

@property (nonatomic, strong) NSURL *url;
@end
