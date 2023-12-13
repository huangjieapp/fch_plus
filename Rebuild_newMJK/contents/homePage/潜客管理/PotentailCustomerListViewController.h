//
//  PotentailCustomerViewController.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/22.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,customerListTimeType){
    customerListTimeTypeNormal=0,
    customerListTimeTypeToday,
    customerListTimeTypeThreeDay,
    customerListTimeTypeOverDay,
    
    customerListTimeTypeRecordToFollow,   //电话录音 填写跟进
    
    
    
};



@interface PotentailCustomerListViewController : DBBaseViewController

/** <#注释#>*/
@property (nonatomic, strong) NSString *loudou;
/** searchStr*/
@property (nonatomic, strong) NSString *tabSearchStr;
/** isAdd*/
@property (nonatomic, assign) BOOL isAdd;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isTab;
/** is list or sea*/
@property (nonatomic, strong) NSString *isListOrSea;

@property(nonatomic,assign)customerListTimeType timerType;
@property(nonatomic,strong)NSString*CREATE_TIME;
@property(nonatomic,strong)NSString*NEWFOLLOW_TIME_TYPE;//最后跟进时间

/** 客户中心*/
@property(nonatomic,strong) NSString *saleCode;
//电话录音转跟进 特有
@property(nonatomic,strong)NSString*recordID;
@property(nonatomic,weak)UIViewController*followVC;

@property (nonatomic,strong) NSString *FOLLOW_TIME_TYPE;
/** typeStr*/
@property (nonatomic, strong) NSString *typeStr;
/** C_APPSOURCE_DD_ID*/
@property (nonatomic, strong) NSString *C_APPSOURCE_DD_ID;
/** IS_A47700*/
@property (nonatomic, strong) NSString *IS_A47700;
/** DD_TYPE*/
@property (nonatomic, strong) NSString *DD_TYPE;
@property (nonatomic, strong) NSString *I_SFSY;

@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *LASTFOLLOW_START_TIME;
@property (nonatomic, strong) NSString *LASTFOLLOW_END_TIME;

@end
