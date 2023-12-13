//
//  MJKMessageDetailModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/22.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMessageDetailModel : MJKBaseModel
/** 消息id*/
@property (nonatomic, strong) NSString *C_ID;
/** 状态code*/
@property (nonatomic, strong) NSString *C_STATE_DD_ID;
/** 状态*/
@property (nonatomic, strong) NSString *C_STATE_DD_NAME;
/** 消息内容*/
@property (nonatomic, strong) NSString *X_CONTENT;
/** 消息发送时间*/
@property (nonatomic, strong) NSString *D_SENDTIME;
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** 业务数据记录id*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** 类型code*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** 类型*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;


@property (nonatomic, strong) NSString *C_TITLE;

@property (nonatomic, strong) NSString *C_TITLE_NAME;
/** 被标记为已读时间*/
@property (nonatomic, strong) NSString *D_RECIPIENTTIME;
/** 跳转页面的类型code*/
@property (nonatomic, strong) NSString *type;
/** 跳转页面的类型*/
@property (nonatomic, strong) NSString *typeName;
/** <#备注#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
