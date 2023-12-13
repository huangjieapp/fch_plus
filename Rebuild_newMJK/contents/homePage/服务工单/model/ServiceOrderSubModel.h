//
//  ServiceOrderSubModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOrderSubModel : MJKBaseModel
@property(nonatomic,strong)NSString*B_ALLCOST;       //费用合计
@property(nonatomic,strong)NSString*C_A41500_C_ID;   //客户id
@property(nonatomic,strong)NSString*C_A41500_C_NAME;   //客户名称
@property(nonatomic,strong)NSString*C_ADDRESS;       //上门地址
@property(nonatomic,strong)NSString*C_CONTACTPHONE;   //客户电话
@property(nonatomic,strong)NSString*C_HEADIMGURL;    //客户头像
@property(nonatomic,strong)NSString*C_ID;       //工单id
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;   //服务人员id
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;   //服务人员
@property(nonatomic,strong)NSString*C_STATUS_DD_ID;   //状态id
@property(nonatomic,strong)NSString*C_STATUS_DD_NAME;   //状态    完成
@property(nonatomic,strong)NSString*C_TYPE_DD_ID;   //任务类型id
@property(nonatomic,strong)NSString*C_TYPE_DD_NAME;    //任务类型

@property(nonatomic,copy) NSString * C_LEVEL_DD_ID;
@property(nonatomic,copy) NSString * C_LEVEL_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_NAME;
@property(nonatomic,copy) NSString * C_STAGE_DD_ID;
@property(nonatomic,copy) NSString * D_LASTFOLLOW_TIME;



@end



//{
//    "B_ALLCOST" = "0.00";
//    "C_A41500_C_ID" = "A4150000000092-1498705371c4ovdfu56f";
//    "C_A41500_C_NAME" = "\U5218";
//    "C_ADDRESS" = "\U4e0a\U6d77\U5e02\U6768\U6d66\U533a\U56fd\U5b9a\U4e1c\U8def200\U53f7";
//    "C_CONTACTPHONE" = 15187648799;
//    "C_HEADIMGURL" = "";
//    "C_ID" = "A0130000000092-150544707174bfe4f9-9";
//    "C_OWNER_ROLEID" = 00000094;
//    "C_OWNER_ROLENAME" = "\U5218\U6881\U6881";
//    "C_STATUS_DD_ID" = "A01300_C_STATUS_0000";
//    "C_STATUS_DD_NAME" = "\U5b8c\U6210";
//    "C_TYPE_DD_ID" = "A01200_C_TYPE_0001";
//    "C_TYPE_DD_NAME" = "\U4e0a\U95e8\U5b89\U88c5";
//}
