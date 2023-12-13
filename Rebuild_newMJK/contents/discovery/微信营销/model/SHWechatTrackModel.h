//
//  SHWechatTrackModel.h
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHWechatTrackModel : MJKBaseModel
//创建时间
@property (nonatomic, strong) NSString *D_CREATE_TIME;
//轨迹内容
@property (nonatomic, strong) NSString *X_REMARK;
/** 轨迹类型id 当为A52100_C_TYPE_0004时是发送消息*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
//轨迹类型
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
//轨迹类型id
@property (nonatomic, strong) NSString *C_SCTYPE_DD_ID;
//轨迹类型
@property (nonatomic, strong) NSString *C_SCTYPE_DD_NAME;
/** 素材链接（当C_SCTYPE_DD_ID的值为A52100_C_SCTYPE_0000图文，
 A52100_C_SCTYPE_0001图片，A52100_C_SCTYPE_0002音频，
 A52100_C_SCTYPE_0003视频时，此字段返回相应链接）*/
@property (nonatomic, strong) NSString *X_URL;

@end
