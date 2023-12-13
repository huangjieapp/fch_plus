//
//  CustomerDetailPathModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerDetailPathDetailModel.h"

@interface CustomerDetailPathModel : MJKBaseModel

@property(nonatomic,strong)NSArray*content;  //具体某一条的数据
@property(nonatomic,strong)NSArray*list;  //具体某一条的数据
@property(nonatomic,strong)NSString*B_ALLCOUNT;     //全部
@property(nonatomic,strong)NSString*B_APPOINTMENTCOUNT;   //预约
@property(nonatomic,strong)NSString*B_CALLCOUNT;   //来电
@property(nonatomic,strong)NSString*B_CLUECOUNT;  //线索
@property(nonatomic,strong)NSString*B_FLOWCOUNT;   //流量
@property(nonatomic,strong)NSString*B_GONGDAN;     //工单
@property(nonatomic,strong)NSString*B_OFFERCOUNT;
@property(nonatomic,strong)NSString*B_ORDERCOUNT;   //订单
@property(nonatomic,strong)NSString*B_FOLLOWCOUNT;   //跟进
@property(nonatomic,strong)NSString*B_TASK;//任务

@property (nonatomic, copy) NSString *B_BB;
@property (nonatomic, copy) NSString *B_HYGH;
@property (nonatomic, copy) NSString *B_DT;


@property (nonatomic, copy) NSString *B_JF;


@property (nonatomic, copy) NSString *C_A47700_C_ID;

@property (nonatomic, copy) NSString *C_OBJECTID;

@property (nonatomic, copy) NSString *C_TYPE_DD_ID;

@property (nonatomic, copy) NSString *C_TYPE_DD_NAME;

@property (nonatomic, copy) NSString *X_REMARK;

@property (nonatomic, copy) NSString *D_SHOW_TIME;


@end

//{
//    "C_MODEFOLLOW_DD_ID" = "";
//    "C_MODEFOLLOW_DD_NAME" = "";
//    "C_NAME" = "";
//    "C_OBJECT_ID" = "A42000000000011-150606516643cc5628-e";
//    "C_TYPE" = "\U8ba2\U5355";
//    "D_SHOW_TIME" = "2017-09-22";
//    "I_TYPE" = 4;
//    "X_REMARK" = "\U603b\U4ef7:1545458.00\n\U5907\U6ce8:";
//},




//{
//    "B_ALLCOUNT" = 8;
//    "B_APPOINTMENTCOUNT" = 0;
//    "B_CALLCOUNT" = 0;
//    "B_CLUECOUNT" = 0;
//    "B_FLOWCOUNT" = 1;
//    "B_FOLLOWCOUNT" = 0;
//    "B_GONGDAN" = 0;
//    "B_OFFERCOUNT" = 0;
//    "B_ORDERCOUNT" = 7;
//    code = 200;
//    content =     (
//    );
//    message = "\U64cd\U4f5c\U6210\U529f";
//}
