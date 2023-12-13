//
//  ServiceTaskDetailModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/30.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceTaskDetailModel : MJKBaseModel
/** <#注释#>*/

@property (nonatomic, strong) NSString *C_A42000_C_ID;
@property (nonatomic, strong) NSString *USER_ID;
@property (nonatomic, strong) NSString *USER_NAME;
@property (nonatomic, strong) NSString *C_A47300_C_ID;
@property(nonatomic,strong)NSString*B_CUSTOMER_LAT;   //客户地址纬度
@property(nonatomic,strong)NSString*B_CUSTOMER_LON;   //客户地址经度
@property(nonatomic,strong)NSString*B_SIGN_LAT;    //签到纬度
@property(nonatomic,strong)NSString*B_SIGN_LON;     //签到经度
@property(nonatomic,strong)NSString*C_A41500_C_ID;   //客户id
@property(nonatomic,strong)NSString*C_A41500_C_NAME;   //客户名称
@property(nonatomic,strong)NSString*C_ADDRESS;         //上门地址
@property(nonatomic,strong)NSString*C_CONTACTPHONE;    //客户电话
@property(nonatomic,strong)NSString*C_HEADIMGURL;     //客户头像
@property(nonatomic,strong)NSString*C_ID;             //任务id
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;    //服务人员id
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;    //服务人员
@property(nonatomic,strong)NSString*C_CREATOR_ROLEID;    //创建id
@property(nonatomic,strong)NSString*C_CREATOR_ROLENAME;    //创建
@property(nonatomic,strong)NSString*C_STATUS_DD_ID;      //状态id
@property(nonatomic,strong)NSString*C_STATUS_DD_NAME;    //状态
@property(nonatomic,strong)NSString*C_TYPE_DD_ID;     //任务类型id
@property(nonatomic,strong)NSString*C_TYPE_DD_NAME;    //任务类型
@property(nonatomic,strong)NSString*D_CREATE_TIME;
@property(nonatomic,strong)NSString*D_ORDER_TIME;    //要求到达时间
@property(nonatomic,strong)NSString*D_SIGNTIME_TIME;   //签到时间
@property(nonatomic,strong)NSString*X_PICURL;   //图片地址（多个以逗号隔开）
@property(nonatomic,strong)NSString*X_REMARK;   //备注
@property (nonatomic, strong) NSString *X_TASKCONTENT;
@property (nonatomic, strong) NSString *D_FINISH_TIME;
@property (nonatomic, strong) NSString *C_FINISHADDRESS;
@property (nonatomic, strong) NSString *C_OPERATOR;//执行人
@property (nonatomic, strong) NSString *ISOWN;

/** 客户等级id（仅脉居客支持）*/
@property (nonatomic, strong) NSString *C_LEVEL_DD_ID;
/** 客户等级（仅脉居客支持）*/
@property (nonatomic, strong) NSString *C_LEVEL_DD_NAME;
/** 客户阶段id（仅脉居客支持）*/
@property (nonatomic, strong) NSString *C_STAGE_DD_ID;
/** 客户阶段（仅脉居客支持）*/
@property (nonatomic, strong) NSString *C_STAGE_DD_NAME;
/** 客户下次跟进时间（仅脉居客支持）*/
@property (nonatomic, strong) NSString *D_LASTFOLLOW_TIME;
/** 预计开始时间*/
@property (nonatomic, strong) NSString *D_START_TIME;
/** 预计完成时间*/
@property (nonatomic, strong) NSString *D_END_TIME;
/** 优先等级*/
@property (nonatomic, strong) NSString *C_TASKSTATUS_DD_ID;
/** 优先等级*/
@property (nonatomic, strong) NSString *C_TASKSTATUS_DD_NAME;
/** 已用天数*/
@property (nonatomic, strong) NSString *ALREADYDAY;
/** 是否超时*/
@property (nonatomic, strong) NSString *TIMEOUT;
/** 签到地址*/
@property (nonatomic, strong) NSString *C_SIGNADDRESS;
/** 签到人*/
@property (nonatomic, strong) NSString *C_PROPOSER;

/** 图片*/
@property (nonatomic, strong) NSArray *urlList;

/** 期望开始时间*/
@property (nonatomic, strong) NSString *D_CONFIRMED_TIME;
/** 是否外出
 是返回1
 否返回0*/
@property (nonatomic, strong) NSString *I_TYPE;
@property (nonatomic, strong) NSString *C_NAME;

@end


//{
//    "B_CUSTOMER_LAT" = 0;
//    "B_CUSTOMER_LON" = 0;
//    "B_SIGN_LAT" = 0;
//    "B_SIGN_LON" = 0;
//    "C_A41500_C_ID" = "A4150000000089-1509095203";
//    "C_A41500_C_NAME" = "\U54ce\U4e00\U53e4";
//    "C_ADDRESS" = kjgjb;
//    "C_CONTACTPHONE" = 69856885555;
//    "C_HEADIMGURL" = "";
//    "C_ID" = "A0120000000092-1509346550";
//    "C_OWNER_ROLEID" = 00000094;
//    "C_OWNER_ROLENAME" = "\U5218\U6881\U6881";
//    "C_STATUS_DD_ID" = "A01200_C_STATUS_0000";
//    "C_STATUS_DD_NAME" = "\U672a\U786e\U8ba4";
//    "C_TYPE_DD_ID" = "A01200_C_TYPE_0002";
//    "C_TYPE_DD_NAME" = "\U4e0a\U95e8\U7ef4\U4fee";
//    "D_ORDER_TIME" = "2017-11-02 14:55";
//    "D_SIGNTIME_TIME" = "";
//    "X_PICURL" = "http://7xt9pc.com1.z0.glb.clouddn.com/png/2017-10-30/f063a363-6c18-4ce6-bf40-02571447bd10.png,http://7xt9pc.com1.z0.glb.clouddn.com/png/2017-10-30/e6d3590d-9d3e-4a85-b59e-0bb045f9ce57.png";
//    "X_REMARK" = Tttttt;
//    code = 200;
//    message = "\U64cd\U4f5c\U6210\U529f";
//}
