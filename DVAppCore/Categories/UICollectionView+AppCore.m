//
//  UICollectionView+AppCore.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "UICollectionView+AppCore.h"

#import "ACReusable.h"

#import "UINib+AppCore.h"
#import "NSObject+AppCore.h"

@implementation UICollectionView(AppCore)

- (void)ac_registerSupplementaryViewClass:(Class)headerFooterViewClass ofKind:(NSString *)kind {
    [self ac_checkClass:headerFooterViewClass isConformsToProtocol:@protocol(ACReusable)];
    
    UINib *nib = [UINib ac_nibWithNibClass:headerFooterViewClass];
    if (nib) {
        [self registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:[headerFooterViewClass reusableIdentifier]];
    } else {
        [self registerClass:headerFooterViewClass forSupplementaryViewOfKind:kind withReuseIdentifier:[headerFooterViewClass reusableIdentifier]];
    }
}

- (void)ac_registerCellClass:(Class)cellClass {
    [self ac_checkClass:cellClass isConformsToProtocol:@protocol(ACReusable)];
    
    UINib *nib = [UINib ac_nibWithNibClass:cellClass];
    if (nib) {
        [self registerNib:nib forCellWithReuseIdentifier:[cellClass reusableIdentifier]];
    } else {
        [self registerClass:cellClass forCellWithReuseIdentifier:[cellClass reusableIdentifier]];
    }
}

@end
