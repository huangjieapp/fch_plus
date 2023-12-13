//
//  MJKSatisfactionView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/22.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKSatisfactionView : UIView
/** 订单缩减编号*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** 已评价*/
@property (nonatomic, strong) NSString *satisfaction_flag;
@end
