//
//  CGCOrderListVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/7.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBBaseViewController.h"

#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>

typedef void(^CLICKBLOCK)(NSIndexPath *index);

@interface CGCOrderListVC : DBBaseViewController<MFMessageComposeViewControllerDelegate>
/** 有无tab*/
@property (nonatomic, strong) NSString *isTab;
/** <#注释#>*/
@property (nonatomic, strong) NSString *loudou;
@property (nonatomic, copy) CLICKBLOCK clickBlock;

@property (nonatomic, strong) NSString *createTimeType;//创建
@property (nonatomic, strong) NSString *QUEREN_TIME_TYPE;//收款创建
@property (nonatomic, strong) NSString * SEND_TIME_TYPE;//已交付
@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *statusID;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *LASTFOLLOW_TIME_TYPE;
@property (nonatomic, copy) NSString *LASTFOLLOW_END_TIME;

@property (nonatomic, strong) NSString *IS_ASSISTANT;
/** 状态*/
@property (nonatomic, strong) NSString *statusStr;
/** 客户中心*/
@property(nonatomic,strong) NSString *saleCode;
/** customer center order status string*/
@property (nonatomic, strong) NSString *cciss;
/** CUSTOMERTYPE*/
@property (nonatomic, strong) NSString *CUSTOMERTYPE;

/** <#注释#> */
@property (nonatomic, strong) NSString *carChoose;
/** <#注释#> */
@property (nonatomic, copy) void(^chooseOrderBlock)(NSString *orderId);


@end
