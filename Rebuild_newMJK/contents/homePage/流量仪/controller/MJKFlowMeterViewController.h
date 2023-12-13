//
//  MJKFlowMeterViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKFlowMeterViewController : UIViewController
/** 是否tab页今日*/
@property (nonatomic, assign) BOOL isTab;
/** 是否tab页今日*/
@property (nonatomic, assign) BOOL isAdd;
/** CREATE_TIME_TYPE*/
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;
/** saleCode*/
@property (nonatomic, strong) NSString *saleCode;
/** <#注释#>*/
@property (nonatomic, strong) UIViewController *superVC;

/** <#注释#>*/
@property (nonatomic, strong) NSString *END_TIME;
@property (nonatomic, strong) NSString *C_ARRIVAL_DD_ID;
@end
