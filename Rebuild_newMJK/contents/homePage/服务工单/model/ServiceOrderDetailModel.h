//
//  ServiceOrderDetailModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/1.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOrderDetailModel : MJKBaseModel
@property(nonatomic,strong)NSString*C_A41500_C_ID;     //客户id
@property(nonatomic,strong)NSString*C_A41500_C_NAME;     //客户名称
@property(nonatomic,strong)NSString*C_ADDRESS;        //上门地址
@property(nonatomic,strong)NSString*C_CONTACTPHONE;    //客户电话
@property(nonatomic,strong)NSString*C_HEADIMGURL;    //客户头像
@property(nonatomic,strong)NSString*C_ID;             //工单id
@property(nonatomic,strong)NSString*C_OWNER_ROLEID;   //服务人员id
@property(nonatomic,strong)NSString*C_OWNER_ROLENAME;   //服务人员
@property(nonatomic,strong)NSString*C_SIGPICTURE;              //签名图片地址
@property(nonatomic,strong)NSString*C_STATUS_DD_ID;   //状态id
@property(nonatomic,strong)NSString*C_STATUS_DD_NAME;  //状态
@property(nonatomic,strong)NSString*C_TYPE_DD_ID;     //工单类型id
@property(nonatomic,strong)NSString*C_TYPE_DD_NAME;    //工单类型
@property(nonatomic,strong)NSString*D_END_TIME;         //完成时间  
@property(nonatomic,strong)NSString*D_ORDER_TIME;     //要求到达时间
@property(nonatomic,strong)NSString*D_START_TIME;       //开始时间
@property(nonatomic,strong)NSString*X_PICURL;         //图片地址（多个以逗号隔开）
@property(nonatomic,strong)NSString*X_WORKCONTENT;     //工作描述
/** urlList*/
@property (nonatomic, strong) NSArray *urlList;


@end


//{
//    "C_A41500_C_ID" = "A4150000000092-1497232906y8ftl9v9ga";
//    "C_A41500_C_NAME" = "\U674e\U5148\U751f";
//    "C_ADDRESS" = "\U4e0a\U6d77\U6768\U6d66";
//    "C_CONTACTPHONE" = 15845484686;
//    "C_HEADIMGURL" = "http://dj.reconova.com/upload/report/2017-06-11/00E0B416480F/ee80d0e4-bc3e-483a-9d44-8a7e713b83a7.jpg";
//    "C_ID" = "A0130000000092-1509525000";
//    "C_OWNER_ROLEID" = 00000094;
//    "C_OWNER_ROLENAME" = "\U5218\U6881\U6881";
//    "C_SIGPICTURE" = "";
//    "C_STATUS_DD_ID" = "A01300_C_STATUS_0001";
//    "C_STATUS_DD_NAME" = "\U672a\U5b8c\U6210";
//    "C_TYPE_DD_ID" = "A01200_C_TYPE_0001";
//    "C_TYPE_DD_NAME" = "\U4e0a\U95e8\U5b89\U88c5";
//    "D_END_TIME" = "";
//    "D_ORDER_TIME" = "2017-10-14 15:22";
//    "D_START_TIME" = "2017-06-27 09:39";
//    "X_PICURL" = "";
//    "X_WORKCONTENT" = "";
//    code = 200;
//    message = "\U64cd\U4f5c\U6210\U529f";
//}
