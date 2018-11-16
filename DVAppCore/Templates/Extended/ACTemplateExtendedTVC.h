//
//  ACTemplateExtendedTVC.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateTVC.h"
#import "ACSectionDescriber.h"

@interface ACTemplateExtendedTVC : ACTemplateTVC
@property (nonatomic, copy) NSArray<ACSectionDescriber *> *sectionDescribers;
@end
