//
//  ACImagePicker.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 22/11/2016.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "ACImagePicker.h"

#import "ACSingleton.h"

#import "NSArray+AppCore.h"
#import "NSString+AppCore.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ACImagePicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIViewController<ACImagePickerDelegate> *targetVC;
@end

@implementation ACImagePicker
ACSINGLETON_M

+ (void)showSheetWithTitle:(NSString *)title
                   message:(NSString *)message
                 takeTitle:(NSString *)takeTitle
               chooseTitle:(NSString *)chooseTitle
               cancelTitle:(NSString *)cancelTitle
                  targetVC:(UIViewController<ACImagePickerDelegate> *)target
             allowsEditing:(BOOL)allowsEditing
                mediaTypes:(ACMediaType)mediaTypes {
    if (!target) return;
    
    ACImagePicker *acImagePicker = [self getInstance];
    [acImagePicker setTargetVC:target];
    
    void (^showImagePicker)(UIImagePickerControllerSourceType) = ^void(UIImagePickerControllerSourceType sourceType) {
        if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            
            UIImagePickerController *imagePicker = [UIImagePickerController new];
            imagePicker.delegate = acImagePicker;
            imagePicker.allowsEditing = allowsEditing;
            imagePicker.mediaTypes = [acImagePicker preparedMediaTypes:mediaTypes];
            imagePicker.sourceType = sourceType;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [acImagePicker.targetVC presentViewController:imagePicker animated:YES completion:nil];
            });
        }
    };
    
#warning TODO corrected default buttons titles
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:(ValidStr(takeTitle) ? takeTitle : @"Take")
                                                        style:UIAlertActionStyleDefault
                                                      handler:
                                ^(UIAlertAction * _Nonnull action) {
                                    showImagePicker(UIImagePickerControllerSourceTypeCamera);
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:(ValidStr(chooseTitle) ? chooseTitle : @"Choose")
                                                        style:UIAlertActionStyleDefault
                                                      handler:
                                ^(UIAlertAction * _Nonnull action) {
                                    showImagePicker(UIImagePickerControllerSourceTypePhotoLibrary);
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:(ValidStr(cancelTitle) ? cancelTitle : @"Cancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [acImagePicker.targetVC presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void)showSheetWithButtonTakeTitle:(NSString *)takeTitle
                         chooseTitle:(NSString *)chooseTitle
                         cancelTitle:(NSString *)cancelTitle
                            targetVC:(UIViewController<ACImagePickerDelegate> *)target
                       allowsEditing:(BOOL)allowsEditing
                          mediaTypes:(ACMediaType)mediaTypes {
    [self showSheetWithTitle:nil
                     message:nil
                   takeTitle:takeTitle
                 chooseTitle:chooseTitle
                 cancelTitle:cancelTitle
                    targetVC:target
               allowsEditing:allowsEditing
                  mediaTypes:mediaTypes];
}

+ (void)showSheetWithTargetVC:(UIViewController<ACImagePickerDelegate> *)target allowsEditing:(BOOL)allowsEditing mediaTypes:(ACMediaType)mediaTypes {
    [self showSheetWithButtonTakeTitle:nil chooseTitle:nil cancelTitle:nil targetVC:target allowsEditing:allowsEditing mediaTypes:mediaTypes];
}

+ (void)showSheetWithTargetVC:(UIViewController<ACImagePickerDelegate> *)target {
    [self showSheetWithTargetVC:target allowsEditing:NO mediaTypes:ACMediaTypePhoto];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.targetVC && [self.targetVC respondsToSelector:@selector(ac_imagePickerController:didFinishPickingMedia:)]) {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            [self.targetVC ac_imagePickerController:self didFinishPickingMedia:info[UIImagePickerControllerOriginalImage]];
        } else if ([mediaType isEqualToString:(NSString *)kUTTypeVideo]) {
#warning TODO add video
        }
    }
    [self imagePickerControllerDidCancel:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utils
- (NSArray<NSString *> *)preparedMediaTypes:(ACMediaType)mediaTypes {
    NSMutableArray *preparedMediaTypes = [NSMutableArray new];
    
    if (mediaTypes & ACMediaTypePhoto) {
        [preparedMediaTypes addObject:(NSString *)kUTTypeImage];
    }
    if (mediaTypes & ACMediaTypeVideo) {
        [preparedMediaTypes addObject:(NSString *)kUTTypeVideo];
    }
    
    return ValidArray(preparedMediaTypes) ? [NSArray arrayWithArray:preparedMediaTypes] : nil;
}

@end
