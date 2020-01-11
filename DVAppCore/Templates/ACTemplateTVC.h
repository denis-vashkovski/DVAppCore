//
//  ACTemplateTVC.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 15/02/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableViewController+AppCore.h"

#import "ACUpdaterVCProtocol.h"

@interface ACTemplateTVC : UITableViewController<ACUpdaterVCProtocol>
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, readonly, getter=isViewAppearNotFirstTime) BOOL viewAppearNotFirstTime;
@end
