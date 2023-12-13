//
//  NoticeInfoModel.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/22.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeInfoModel : MJKBaseModel

@property(nonatomic,strong)NSString*C_BACKGROUND;
@property(nonatomic,strong)NSString*C_CREATOR_ROLEID;
@property(nonatomic,strong)NSString*C_CREATOR_ROLENAME;
@property(nonatomic,strong)NSString*C_ID;
@property(nonatomic,strong)NSString*C_JUMP_URL;
@property(nonatomic,strong)NSString*C_SHARE_PICTURE;
@property(nonatomic,strong)NSString*C_SHARE_STATUS_DD_NAME;
@property(nonatomic,strong)NSString*C_SHOW_TYPE_DD_NAME;
@property(nonatomic,strong)NSString*C_TITLE;           //内标题
@property(nonatomic,strong)NSString*D_CREATE_TIME;
@property(nonatomic,strong)NSString*IS_SHARE_FLAG;
@property(nonatomic,strong)NSString*X_SHARE_CONTENT;   //内容

/** 阅读人头像*/
@property (nonatomic, strong) NSArray *readerHeads;
/** 阅读数*/
@property (nonatomic, assign) NSInteger readerCount;
/** 图片*/
@property (nonatomic, strong) NSArray *urlList;



@end



//{
//    "C_BACKGROUND" = "";
//    "C_CREATOR_ROLEID" = 00000118;
//    "C_CREATOR_ROLENAME" = "\U7eaa\U4e1c\U826f";
//    "C_ID" = "A4210000000116-1502702355p3gw2e2d8t";
//    "C_JUMP_URL" = "mobile/banner/infomation_banner.jsp?C_A42100_C_ID=A4210000000116-1502702355p3gw2e2d8t&iswx=0&user_id=00000092";
//    "C_SHARE_PICTURE" = "";
//    "C_SHARE_STATUS_DD_NAME" = "\U4e0d\U5206\U4eab";
//    "C_SHOW_TYPE_DD_NAME" = "\U5426";
//    "C_TITLE" = "\U5c4b\U5b50";
//    "D_CREATE_TIME" = "2017\U5e7408\U670814\U65e5";
//    "IS_SHARE_FLAG" = false;
//    "X_SHARE_CONTENT" = "\U8ffd\U5267\U966a\U6211\U7559\U80e1\U5b50";
//}
