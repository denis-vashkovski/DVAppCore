//
//  ACDesignableView.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACDesignableView.h"

IB_DESIGNABLE

@interface ACDesignableView()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation ACDesignableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    //    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    [[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class)
                                                 owner:self
                                               options:nil];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight);
    
    [self addSubview:self.contentView];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self setup];
}

@end
