//
//  MJKDiviceCheckViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKDiviceCheckViewController : DBBaseViewController
/** C_ACCOUNTNAME*/
@property (nonatomic, strong) NSString *C_ACCOUNTNAME;
/** BchannelId*/
@property (nonatomic, strong) NSString *BchannelId;
/** BPushappId*/
@property (nonatomic, strong) NSString *BPushappId;
/** 是否几天未登录验证设备*/
@property (nonatomic, assign) BOOL isMoreTimeNotLoggedIn;
@end
