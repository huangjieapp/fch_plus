//
//  MJKTelephoneRobotResultViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRobotResultViewController : UIViewController
/** C_A70100_C_ID*/
@property (nonatomic, strong) NSString *C_A70100_C_ID;
/** 通话结果*/
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** 意图*/
@property (nonatomic, strong) NSString *intentionDesc;
@end

NS_ASSUME_NONNULL_END
