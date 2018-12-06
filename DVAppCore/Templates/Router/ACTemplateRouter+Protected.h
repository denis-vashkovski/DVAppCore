//
//  ACTemplateRouter+Protected.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 06/12/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateRouter.h"

@interface ACTemplateRouter(Protected)
- (void)setViewController:(UIViewController *)viewController;
- (UIViewController *)viewController;
@end
