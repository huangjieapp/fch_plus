//
//  MJKAddTelephoneRobotViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/19.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAddTelephoneRobotViewController : DBBaseViewController
/**记录来源
 名单列表A70100_C_SOURCE_0000
 公海列表A70100_C_SOURCE_0001
 客户列表A70100_C_SOURCE_0002*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;
@end

NS_ASSUME_NONNULL_END
