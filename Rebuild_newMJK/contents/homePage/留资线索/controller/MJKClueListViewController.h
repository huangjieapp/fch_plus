//
//  MJKClueListViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,clueListTimeType){
	clueListTimeTypeNormal=0,
	clueListTimeTypeToday,
	clueListTimeTypeThreeDay,
	clueListTimeTypeOverDay,
};

@interface MJKClueListViewController : DBBaseViewController
/** tab点击新增*/
@property (nonatomic, assign) BOOL isAdd;
/** 是否tab页今日*/
@property (nonatomic, assign) BOOL isTab;
/** 是否有新增按钮*/
@property (nonatomic, strong) NSString *haveAddButton;

@property(nonatomic,assign)clueListTimeType timerType;
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;//创建时间
@property (nonatomic, strong) NSString *saleCode;//筛选的销售code
@property (nonatomic, strong) NSString *stateCode;//筛选的状态code
@property (nonatomic, strong) NSString *nextTime;
/** IS_A47700*/
@property (nonatomic, strong) NSString *IS_A47700;
/** 创建人我和我的下级*/
@property (nonatomic, strong) NSString *TABTYPE;
/** <#注释#>*/
@property (nonatomic, strong) NSString *I_SFSY;
@property (nonatomic, strong) NSString *LEAD_START_TIME;
@property (nonatomic, strong) NSString *LEAD_END_TIME;

@end
