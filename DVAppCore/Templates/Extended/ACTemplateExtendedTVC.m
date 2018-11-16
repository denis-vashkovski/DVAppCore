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

#import "UITableView+AppCore.h"

@implementation ACTemplateExtendedTVC

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
    ACViewDescriber *headerDescriber = self.sectionDescribers[section].header;
    if (!headerDescriber) return nil;
    
    [self checkIfReusableProtocolWasImplementedIn:headerDescriber.viewClass];
    NSString *reusableIdentifier = [headerDescriber.viewClass reusableIdentifier];
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    if (!headerView) {
        [tableView ac_registerHeaderFooterViewClass:headerDescriber.viewClass];
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    }
    
    [(id<ACDescribable>)headerView configureWithViewDescriber:headerDescriber];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.sectionDescribers[section].footer.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ACViewDescriber *footerDescriber = self.sectionDescribers[section].footer;
    if (!footerDescriber) return nil;
    
    [self checkIfReusableProtocolWasImplementedIn:footerDescriber.viewClass];
    NSString *reusableIdentifier = [footerDescriber.viewClass reusableIdentifier];
    
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    if (!footerView) {
        [tableView ac_registerHeaderFooterViewClass:footerDescriber.viewClass];
        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusableIdentifier];
    }
    
    [(id<ACDescribable>)footerView configureWithViewDescriber:footerDescriber];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sectionDescribers[indexPath.section] cellDescriberForIndex:indexPath.row].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACViewDescriber *cellDescriber = [self.sectionDescribers[indexPath.section] cellDescriberForIndex:indexPath.row];
    
    [self checkIfReusableProtocolWasImplementedIn:cellDescriber.viewClass];
    NSString *reusableIdentifier = [cellDescriber.viewClass reusableIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    if (!cell) {
        [tableView ac_registerCellClass:cellDescriber.viewClass];
        cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    }
    
    [(id<ACDescribable>)cell configureWithViewDescriber:cellDescriber];
    
    return cell;
}

#pragma mark - Utils
- (void)checkIfReusableProtocolWasImplementedIn:(Class)class {
    NSAssert([class conformsToProtocol:@protocol(ACReusable)], @"'%@' doesn't conform to 'ACReusable'", NSStringFromClass(class));
}

@end
