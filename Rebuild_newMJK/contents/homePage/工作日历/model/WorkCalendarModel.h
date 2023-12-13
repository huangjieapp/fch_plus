//
//  WorkCalendarModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkCalendarModel : MJKBaseModel
/** 任务id*/
@property(nonatomic,strong)NSString*C_A01200_C_ID;
@property(nonatomic,strong)NSString*C_A41500_C_ID;
@property(nonatomic,strong)NSString*C_A41500_C_NAME;   //left bottom
@property(nonatomic,strong)NSString*C_CREATOR_ROLEID;
@property(nonatomic,strong)NSString*C_CREATOR_ROLENAME;
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;   //rightBottom
@property(nonatomic,strong)NSString*C_PROCESS;
@property(nonatomic,strong)NSString*C_TYPE_DD_ID;
@property(nonatomic,strong)NSString*DAY;
@property(nonatomic,strong)NSString*TIME;
@property(nonatomic,strong)NSString*TYPE_NAME;
@property(nonatomic,strong)NSString*X_REMARK;     //left top
@property(nonatomic,strong)NSString*C_ADDRESS;
//C_RWTYPE_DD_NAME 任务类型id
@property(nonatomic,strong)NSString*C_RWTYPE_DD_ID;
//C_RWTYPE_DD_NAME 任务类型名
@property(nonatomic,strong)NSString*C_RWTYPE_DD_NAME;
@property(nonatomic,strong)NSString*C_RWSTATUS_DD_ID;
@property(nonatomic,strong)NSString*C_RWSTATUS_DD_NAME;
/** 任务描述*/
@property (nonatomic, strong) NSString *X_RW_REMARK;


@end



//{
//    "C_A41500_C_ID" = "A4150000000002-150779430789a84230-6";
//    "C_A41500_C_NAME" = sctcgc;
//    "C_CREATOR_ROLEID" = "";
//    "C_CREATOR_ROLENAME" = "";
//    "C_ID" = "A4160000000002-1507794953f781a4ac-d";
//    "C_OWNER_ROLEID" = 00000002;
//    "C_OWNER_ROLENAME" = "\U9500\U552e\U7ecf\U7406";
//    "C_PROCESS" = "\U672a\U5904\U7406";
//    "C_TYPE_DD_ID" = "A41600_C_TYPE_0001";
//    DAY = "2017-10-12";
//    TIME = "15:55";
//    "TYPE_NAME" = "\U8ddf\U8fdb";
//    "X_REMARK" = "\U5582\U5582\U80c3\U5582\U80c3\Uff0c\U5582\U80c3\U3002";
//},
