//
//  ACTemplateCVC.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 03/05/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ACUpdaterVCProtocol.h"

@interface ACTemplateCVC : UICollectionViewController<ACUpdaterVCProtocol>
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, readonly, getter=isViewAppearNotFirstTime) BOOL viewAppearNotFirstTime;
@end
