//
//  ACTemplateExtendedTVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 16/11/2018.
//  Copyright © 2018 Denis Vashkovski. All rights reserved.
//

#import "ACTemplateExtendedTVC.h"

#import "ACViewDescriber.h"

#import "ACReusable.h"
#import "ACDescribable.h"

#import "ACDesignableView+Protected.h"

#import "NSObject+AppCore.h"

#import "UITableView+AppCore.h"
#import "UIView+AppCore.h"

@interface ACTableViewCellDescribable : UITableViewCell<ACDescribable>
@property (nonatomic, strong) UIView<ACDescribable> *describableView;
@end

@implementation ACTableViewCellDescribable

- (void)setDescribableView:(UIView<ACDescribable> *)describableView {
    if (self.describableView) {
        [self.describableView removeFromSuperview];
    }
    
    [self ac_checkClass:describableView.class isConformsToProtocol:@protocol(ACDescribable)];
    
    _describableView = describableView;
    
    if (self.describableView) {
        [self.contentView addSubview:self.describableView];
        [self.describableView ac_addConstraintsEqualSuperview];
    }
}

- (void)configureWithViewDescriber:(ACViewDescriber *)viewDescriber {
    if (!viewDescriber) {
        return;
    }
    
    if (!self.describableView) {
        ACDesignableView<ACDescribable> *view = [viewDescriber.viewClass new];
        [view setup];
        
        self.describableView = view;
    }
    
    [self.describableView configureWithViewDescriber:viewDescriber];
}

@end

@interface ACTableViewHeaderFooterViewDescribable : UITableViewHeaderFooterView<ACDescribable>
@property (nonatomic, strong) UIView<ACDescribable> *describableView;
@end

@implementation ACTableViewHeaderFooterViewDescribable

- (void)setDescribableView:(UIView<ACDescribable> *)describableView {
    if (self.describableView) {
        [self.describableView removeFromSuperview];
    }
    
    [self ac_checkClass:describableView.class isConformsToProtocol:@protocol(ACDescribable)];
    
    _describableView = describableView;
    
    if (self.describableView) {
        [self.contentView addSubview:self.describableView];
        [self.describableView ac_addConstraintsEqualSuperview];
    }
}

- (void)configureWithViewDescriber:(ACViewDescriber *)viewDescriber {
    if (!viewDescriber) {
        return;
    }
    
    if (!self.describableView) {
        ACDesignableView<ACDescribable> *view = [viewDescriber.viewClass new];
        [view setup];
        
        self.describableView = view;
    }
    
    [self.describableView configureWithViewDescriber:viewDescriber];
}

@end

@implementation ACTemplateExtendedTVC

- (void)setTableHeaderViewDesctiber:(ACViewDescriber *)tableHeaderViewDesctiber {
    _tableHeaderViewDesctiber = tableHeaderViewDesctiber;
    
    UIView<ACDescribable> *tableHeaderView = nil;
    if (tableHeaderViewDesctiber) {
        tableHeaderView = [tableHeaderViewDesctiber.viewClass ac_newInstanceFromNib];
    }
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    if (tableHeaderView && [tableHeaderView conformsToProtocol:@protocol(ACDescribable)]) {
        [tableHeaderView configureWithViewDescriber:tableHeaderViewDesctiber];
    }
}

- (void)setTableFooterViewDesctiber:(ACViewDescriber *)tableFooterViewDesctiber {
    _tableFooterViewDesctiber = tableFooterViewDesctiber;
    
    UIView<ACDescribable> *tableFooterView = nil;
    if (tableFooterViewDesctiber) {
        tableFooterView = [tableFooterViewDesctiber.viewClass ac_newInstanceFromNib];
    }
    
    self.tableView.tableFooterView = tableFooterView;
    
    if (tableFooterView && [tableFooterView conformsToProtocol:@protocol(ACDescribable)]) {
        [tableFooterView configureWithViewDescriber:tableFooterViewDesctiber];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDescribers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionDescribers[section].numberOfCells;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionDescribers[section].header.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView viewForHeaderFooterWithDescriber:self.sectionDescribers[section].header];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sectionDescribers[section].footer.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self tableView:tableView viewForHeaderFooterWithDescriber:self.sectionDescribers[section].footer];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sectionDescribers[indexPath.section] cellDescriberForIndex:indexPath.row].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACViewDescriber *cellDescriber = [self.sectionDescribers[indexPath.section] cellDescriberForIndex:indexPath.row];
    
    [self ac_checkClass:cellDescriber.viewClass isConformsToProtocol:@protocol(ACReusable)];
    NSString *reusableIdentifier = [cellDescriber.viewClass reusableIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    if (!cell) {
        if ([cellDescriber.viewClass isSubclassOfClass:UITableViewCell.class]) {
            [tableView ac_registerCellClass:cellDescriber.viewClass];
        } else {
            [tableView registerClass:ACTableViewCellDescribable.class forCellReuseIdentifier:reusableIdentifier];
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    }
    
    [(id<ACDescribable>)cell configureWithViewDescriber:cellDescriber];
    
    return cell;
}

#pragma mark - Private
- (UIView *)tableView:(UITableView *)tableView viewForHeaderFooterWithDescriber:(ACViewDescriber *)headerFooterDescriber {
    if (!headerFooterDescriber) {
        return nil;
    }
    
    [self ac_checkClass:headerFooterDescriber.viewClass isConformsToProtocol:@protocol(ACReusable)];
    NSString *reusableIdentifier = [headerFooterDescriber.viewClass reusableIdentifier];
    
    UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    if (!headerFooterView) {
        if ([headerFooterDescriber.viewClass isSubclassOfClass:UITableViewHeaderFooterView.class]) {
            [tableView ac_registerHeaderFooterViewClass:headerFooterDescriber.viewClass];
        } else {
            [tableView registerClass:ACTableViewHeaderFooterViewDescribable.class forHeaderFooterViewReuseIdentifier:reusableIdentifier];
        }
        
        headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    }
    
    [(id<ACDescribable>)headerFooterDescriber configureWithViewDescriber:headerFooterDescriber];
    
    return headerFooterView;
}

#pragma mark - Utils
- (void)checkIfReusableProtocolWasImplementedIn:(Class)class {
    NSAssert([class conformsToProtocol:@protocol(ACReusable)], @"'%@' doesn't conform to 'ACReusable'", NSStringFromClass(class));
}

@end
