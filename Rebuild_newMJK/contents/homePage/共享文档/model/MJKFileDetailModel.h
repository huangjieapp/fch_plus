//
//  MJKFileDetailModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/7.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKFileDetailModel : MJKBaseModel
/** 附件id*/
@property (nonatomic, strong) NSString *C_ID;
/** 记录id*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** 文件名*/
@property (nonatomic, strong) NSString *C_NAME;
/** 附件链接*/
@property (nonatomic, strong) NSString *C_URL;
/** 上传时间*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** 上传人roleid*/
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
/** 上传人姓名*/
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
/** 录音时长*/
@property (nonatomic, strong) NSString *I_TYPE;
/** 录制开始时间*/
@property (nonatomic, strong) NSString *D_START_TIME;
/** 有效时长*/
@property (nonatomic, strong) NSString *I_YXSC;

@property (nonatomic, strong) NSString *USER_ID;
@property (nonatomic, strong) NSString *USER_NAME;
@property (nonatomic, strong) NSString *X_REMARK;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;


@end

NS_ASSUME_NONNULL_END
