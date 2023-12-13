//
//  CGCAppointmentListVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBBaseViewController.h"

typedef void(^CLICKBLOCK)(NSIndexPath *index);

@interface CGCAppointmentListVC : DBBaseViewController

@property (nonatomic, copy) CLICKBLOCK clickBlock;

@property (nonatomic, strong) NSString *IS_ARRIVE_SHOP;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
@property (nonatomic, strong) NSString *BOOK_START_TIME;
@property (nonatomic, strong) NSString *BOOK_END_TIME;

@property (nonatomic, copy) NSString *BOOK_TIME_TYPE;

@property (nonatomic, copy) NSString *END_BOOK_TIME;

@property(nonatomic, strong) NSString *ARRIVE_TIME_TYPE;

@property(nonatomic, strong) NSString *CREATE_TIME_TYPE;
/** 客户中心*/
@property(nonatomic,strong) NSString *saleCode;

@end
