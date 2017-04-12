//
//  ACUpdaterVCProtocol.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 25/07/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ACUpdaterVCProtocol <NSObject>
- (void)ac_didUpdatedDesign;
- (void)ac_didUpdatedLocalization;
@end
