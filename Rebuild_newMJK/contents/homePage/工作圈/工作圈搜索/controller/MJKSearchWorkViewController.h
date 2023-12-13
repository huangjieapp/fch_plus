//
//  MJKSearchWorkViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/9.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKSearchWorkViewController : DBBaseViewController
/** <#备注#>*/
@property (nonatomic, copy) void(^searchBlock)(NSString *type, NSString *searchText);
@property (nonatomic, copy) void(^searchBackButtonBlock)(void);
@end

NS_ASSUME_NONNULL_END
