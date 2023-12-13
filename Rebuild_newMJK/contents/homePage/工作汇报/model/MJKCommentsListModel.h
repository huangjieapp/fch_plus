//
//  MJKCommentsListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCommentsFileListModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *saveUrl;
@property (nonatomic,strong) NSString *url;
@end

@interface MJKCommentsListModel : MJKBaseModel
/** 评论id*/
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_NAME;
@property (nonatomic, strong) NSString *C_FATHERID;
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
/** <#注释#>*/
@property (nonatomic, strong) NSArray *hf_list;
@property (nonatomic, strong) NSArray *replyList;
@property (nonatomic, strong) NSString *C_OBJECTID;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSArray *fileList;
@end
