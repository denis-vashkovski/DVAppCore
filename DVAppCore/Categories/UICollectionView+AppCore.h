//
//  UICollectionView+AppCore.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView(AppCore)
- (void)ac_registerSupplementaryViewClass:(Class)headerFooterViewClass ofKind:(NSString *)kind;
- (void)ac_registerCellClass:(Class)cellClass;
@end
