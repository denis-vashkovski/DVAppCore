//
//  ViewController.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 12/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ViewController.h"

#import "ACImagePicker.h"
#import "ACRouter.h"

#import "UINavigationController+AppCore.h"

#import "TestTVC.h"
#import "ACWebViewController.h"

@interface ViewController ()<ACImagePickerDelegate>

@end

@implementation ViewController

+ (instancetype)ac_newInstance {
    return (ViewController *)[ACRouter getVCByName:NSStringFromClass([self class]) storyboardName:@"Main"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - ACImagePickerDelegate
- (void)ac_imagePickerController:(ACImagePicker *)acImagePicker didFinishPickingMedia:(id)media {
    NSLog(@"");
}

#pragma mark - Actions
- (IBAction)onRightBarButtonTouch:(id)sender {
    [ACImagePicker showSheetWithButtonTakeTitle:@"Take"
                                    chooseTitle:@"Choose" 
                                    cancelTitle:@"Cancel" 
                                       targetVC:self
                                  allowsEditing:NO
                                     mediaTypes:ACMediaTypePhoto];
}

- (IBAction)onButtonNextTouch:(id)sender {
    [self.navigationController ac_pushViewController:[TestTVC ac_newInstance]
                                       animationType:ACAnimationTransitionFlipFromTop];
    
//    [ACWebViewController openUrl:[NSURL URLWithString:@"https://google.com"] withPushingNVC:self.navigationController];
//    [ACWebViewController openUrl:[NSURL URLWithString:@"https://google.com"] withPresentingVC:self];
}

@end
