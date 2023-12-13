//
//  MJKMarketViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListViewModel.h"
#import "MJKClueListMainSecondModel.h"




@interface MJKMarketViewController : DBBaseViewController
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSArray *chooseArray;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *vcName;
/** 订单到货/完工状态下的收货人需要提示*/
@property (nonatomic, strong) NSString *alertName;

#pragma 选择销售顾问   只需这个回调  不需要参数
@property (nonatomic, copy) void(^backSelectParameterBlock)(NSString *codeStr, NSString *nameStr);
@property (nonatomic, copy) void(^backSuccessBlock)(void);
@end
