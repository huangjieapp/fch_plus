//
//  MJKCarSourceHomeViewController.h
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCarSourceHomeSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCarSourceHomeViewController : DBBaseViewController
/** <#注释#> */
@property (nonatomic, strong) NSString *VCName;

@property (nonatomic, copy) void(^chooseOrderBlock)(MJKCarSourceHomeSubModel *carModel);
@end

NS_ASSUME_NONNULL_END
