//
//  PotentailCustomerListDetailModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PotentailCustomerListDetailModel : MJKBaseModel
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_A40500_C_ID;
@property(nonatomic,strong)NSString*C_A40500_C_NAME;
@property(nonatomic,strong)NSString*C_A40600_C_ID;      //意向车型
@property(nonatomic,strong)NSString*C_A40600_C_NAME;
@property(nonatomic,strong)NSString*C_A41200_C_ID;
@property(nonatomic,strong)NSString*C_A41200_C_NAME;
@property(nonatomic,strong)NSString*C_A41500_C_ID;       //潜客id   c_id
@property(nonatomic,strong)NSString*C_ADDRESS;    //备注   详情用
@property(nonatomic,strong)NSString*C_HEADIMGURL;    //潜客头像
@property(nonatomic,strong)NSString*C_HEADIMGURL_SHOW;
@property(nonatomic,strong)NSString*C_LEVEL_DD_ID;
@property(nonatomic,strong)NSString*C_LEVEL_DD_NAME;   //  H类
@property(nonatomic,strong)NSString*C_NAME;      //潜客名字
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;     //所属销售顾问
@property(nonatomic,strong)NSString*C_PHONE;
@property(nonatomic,strong)NSString*C_FSLX_DD_ID;
@property(nonatomic,strong)NSString*C_SEX_DD_ID;
@property(nonatomic,strong)NSString*C_SEX_DD_NAME;   //女   st
@property(nonatomic,strong)NSString*C_STAGE_DD_ID;     //潜客阶段
@property(nonatomic,strong)NSString*C_STAGE_DD_NAME;
@property(nonatomic,strong)NSString*C_STAR_DD_ID;   //A41500_C_STAR_0001  不是星标    A41500_C_STAR_0000是星标
@property(nonatomic,strong)NSString*C_STAR_DD_NAME;
@property(nonatomic,strong)NSString*C_STATUS_DD_ID;
@property(nonatomic,strong)NSString*C_STATUS_DD_NAME;    // 战败  订单等
@property(nonatomic,strong)NSString*D_LASTFOLLOW_TIME;   //下次跟进时间
@property(nonatomic,strong)NSString*D_ORDER_TIME;
@property(nonatomic,strong)NSString*FLAG;
@property(nonatomic,strong)NSString*STARNUM;

@property(nonatomic,strong)NSString*C_DESIGNER_ROLEID;
@property(nonatomic,strong)NSString*C_DESIGNER_ROLENAME;
@property(nonatomic,strong)NSString*C_A48200_C_ID;
@property(nonatomic,strong)NSString*C_A48200_C_NAME;

@property(nonatomic,strong)NSString*C_OBJECTID;
@property(nonatomic,strong)NSString*C_CLUESOURCE_DD_ID;

@property(nonatomic,strong)NSString*C_CLUESOURCE_DD_NAME;

@property(nonatomic,assign)BOOL isSelected;   //当前的cell 选中状态


@property(nonatomic,strong) NSString *C_A70600_C_ID;
@property(nonatomic,strong) NSString *C_A70600_C_NAME;
@property(nonatomic,strong) NSString *C_A49600_C_ID;
@property(nonatomic,strong) NSString *C_A49600_C_NAME;
@property(nonatomic,strong) NSString *C_A49600_C_PICTURE;
@property(nonatomic,strong) NSString *C_YX_A70600_C_ID;
@property(nonatomic,strong) NSString *C_YX_A70600_C_NAME;
@property(nonatomic,strong) NSString *C_YX_A49600_C_ID;
@property(nonatomic,strong) NSString *C_YX_A49600_C_NAME;
@property(nonatomic,strong) NSString *C_YX_A49600_C_PICTURE;

@end




//{
//    "C_A40500_C_ID" = "A40500IAC00001-15340E8D8283B41I2ZINBN13F8J35P6L5";
//    "C_A40500_C_NAME" = "\U6807\U81f4";
//    "C_A40600_C_ID" = "A40600IAC00001-153269bluesimportP87P48000153";
//    "C_A40600_C_NAME" = "\U6807\U81f42008";
//    "C_A41200_C_ID" = "";
//    "C_A41200_C_NAME" = "";
//    "C_A41500_C_ID" = "A4150000000014-1496492497na30500i1d";
//    "C_ADDRESS" = "";
//    "C_HEADIMGURL" = "";
//    "C_LEVEL_DD_ID" = "A41500_C_LEVEL_0000";
//    "C_LEVEL_DD_NAME" = "H\U7c7b";
//    "C_NAME" = "\U6d4b\U8bd5";
//    "C_OWNER_ROLEID" = 00000016;
//    "C_OWNER_ROLENAME" = tim1;
//    "C_PHONE" = 65498732113;
//    "C_SEX_DD_ID" = "A41500_C_SEX_0001";
//    "C_SEX_DD_NAME" = "\U5973";
//    "C_STAGE_DD_ID" = "A41500_C_STAGE_0000";
//    "C_STAGE_DD_NAME" = "\U8be2\U4ef7\U4e2d";
//    "C_STAR_DD_ID" = "A41500_C_STAR_0001";
//    "C_STAR_DD_NAME" = "";
//    "C_STATUS_DD_ID" = "A41500_C_STATUS_0000";
//    "C_STATUS_DD_NAME" = "\U6b63\U5e38";
//    "D_LASTFOLLOW_TIME" = "10:13";
//    "D_ORDER_TIME" = "11:52";
//    FLAG = false;
//    STARNUM = 1;
//},
