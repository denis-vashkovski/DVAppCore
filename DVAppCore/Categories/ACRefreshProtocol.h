//
//  ACRefreshProtocol.h
//  DVAppCore
//
//  Created by Denis Vashkovski on 26/04/2017.
//  Copyright © 2017 Denis Vashkovski. All rights reserved.
//

@protocol ACRefreshProtocol <NSObject>
- (void)ac_initRefreshView;
- (void)ac_startRefreshing;
- (void)ac_endRefreshing;
- (void)ac_refreshView;
@end
