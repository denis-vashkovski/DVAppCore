//
//  TestTVC.m
//  DVAppCore
//
//  Created by Denis Vashkovski on 23/03/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "TestTVC.h"

#import "UIViewController+AppCore.h"
#import "UITableViewCell+AppCore.h"
#import "UIView+AppCore.h"

#import "ACRouter.h"

@interface TestTVC ()

@end

@implementation TestTVC

+ (instancetype)newInstance {
    return (TestTVC *)[ACRouter getVCByName:@"TestTVC" storyboardName:@"Main"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Empty Cell ID"];
    
    [cell.ac_separatorBottom setHidden:NO];
    [cell.ac_separatorBottom setHeight:2.];
    [cell.ac_separatorBottom setInsets:ACLRInsetsMake(16., 64.)];
    [cell setBackgroundColor:[UIColor darkGrayColor]];
    
    return cell;
}

@end
