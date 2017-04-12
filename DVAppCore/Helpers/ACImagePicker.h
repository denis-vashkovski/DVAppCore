//
//  ACImagePicker.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "NSObject+AppCore.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ACMediaType) {
    ACMediaTypePhoto = 1 << 0,
    ACMediaTypeVideo = 1 << 1
};

@protocol ACImagePickerDelegate;

@interface ACImagePicker : NSObject
AC_STANDART_CREATING_NOT_AVAILABLE(showSheetForVC)

+ (void)showSheetWithTitle:(NSString *)title
                   message:(NSString *)message
                 takeTitle:(NSString *)takeTitle
               chooseTitle:(NSString *)chooseTitle
               cancelTitle:(NSString *)cancelTitle
                  targetVC:(UIViewController<ACImagePickerDelegate> *)target
             allowsEditing:(BOOL)allowsEditing
                mediaTypes:(ACMediaType)mediaTypes;

+ (void)showSheetWithButtonTakeTitle:(NSString *)takeTitle
                         chooseTitle:(NSString *)chooseTitle
                         cancelTitle:(NSString *)cancelTitle
                            targetVC:(UIViewController<ACImagePickerDelegate> *)target
                       allowsEditing:(BOOL)allowsEditing
                          mediaTypes:(ACMediaType)mediaTypes;

+ (void)showSheetWithTargetVC:(UIViewController<ACImagePickerDelegate> *)target
                allowsEditing:(BOOL)allowsEditing
                   mediaTypes:(ACMediaType)mediaTypes;

+ (void)showSheetWithTargetVC:(UIViewController<ACImagePickerDelegate> *)target;
@end

@protocol ACImagePickerDelegate <NSObject>
- (void)ac_imagePickerController:(ACImagePicker *)acImagePicker didFinishPickingMedia:(id)media;
@end
