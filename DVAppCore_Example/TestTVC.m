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
#import "UINavigationController+AppCore.h"

#import "ACRouter.h"

@interface TestTVC ()
@property (nonatomic) BOOL empty;
@end

@implementation TestTVC

+ (instancetype)ac_newInstance {
    return (TestTVC *)[ACRouter getVCByName:@"TestTVC" storyboardName:@"Main"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ac_startLoadingProcess];
    [NSTimer scheduledTimerWithTimeInterval:2. target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.empty ? 0 : 1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.empty = YES;
//    [tableView reloadData];
    [self.navigationController ac_popViewControllerAnimationType:ACAnimationTransitionCrossDissolve];
}

#pragma mark - Actions
- (void)timerAction {
    [self ac_stopLoadingProcess];
}

@end
