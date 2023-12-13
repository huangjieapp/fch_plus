//
//  MJKFlowListViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/6.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,flowListTimeType){
	flowListTimeTypeNormal=0,
	flowListTimeTypeToday,
	flowListTimeTypeThreeDay,
	flowListTimeTypeOverDay,
};

@interface MJKFlowListViewController : DBBaseViewController
/**tab页点新增*/
@property (nonatomic, assign) BOOL isAdd;
/** 是否tab页今日*/
@property (nonatomic, assign) BOOL isTab;

@property (nonatomic, weak) UIViewController *superVC;

@property(nonatomic,assign)flowListTimeType timerType;
//@"返回首页"
@property (nonatomic, strong) NSString *VCName;
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;//创建时间

@property (nonatomic, strong) NSString *saleCode;
@property (nonatomic, strong) NSString *statusCode;
@end
