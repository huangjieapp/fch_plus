//
//  MJKTaskCommentModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskCommentModel : MJKBaseModel
/** 评论id*/
@property (nonatomic, strong) NSString *C_ID;
/** 评论人*/
@property (nonatomic, strong) NSString *C_CREATOR_ROLENAME;
/** 评论时间*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** 评论内容*/
@property (nonatomic, strong) NSString *X_REMARK;
/** 评论人头像*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;

@property (nonatomic, strong) NSString *X_REMINDING;
@property (nonatomic, strong) NSString *X_REMINDINGNAME;
@end

NS_ASSUME_NONNULL_END
