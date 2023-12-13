//
//  MJKTypeFolderModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTypeFolderModel : MJKBaseModel
/** 文件夹id*/
@property (nonatomic, strong) NSString *C_ID;
/** 文件夹名称*/
@property (nonatomic, strong) NSString *C_NAME;
/** 文件分类id*/
@property (nonatomic, strong) NSString *C_A70600_C_ID;
/** 文件分类名称*/
@property (nonatomic, strong) NSString *C_A70600_C_NAME;
/** 查看权限员工（帐号userid英文逗号隔开）*/
@property (nonatomic, strong) NSString *X_CKQX;
@property (nonatomic, strong) NSString *X_CKQX_NAME;
/** 修改权限员工（帐号userid英文逗号隔开）*/
@property (nonatomic, strong) NSString *X_XGQX;
@property (nonatomic, strong) NSString *X_XGQX_NAME;
/** 文件格式*/
@property (nonatomic, strong) NSString *C_WJGS;
/** 是否修改权限*/
@property (nonatomic, strong) NSString *ISXG;
/** 最新一条文件URL*/
@property (nonatomic, strong) NSString *NEWESTURL;
/** 最新的一条文件上传时间*/
@property (nonatomic, strong) NSString *NEWESTTIME;
/** 最新的一条文件上传人userid*/
@property (nonatomic, strong) NSString *NEWESTUSERID;
/** 最新的一条文件上传人username*/
@property (nonatomic, strong) NSString *NEWESTUSERNAME;
/** 最新一条文件的id*/
@property (nonatomic, strong) NSString *NEWESTID;
/** 最新一条文件的文件名*/
@property (nonatomic, strong) NSString *NEWESTNAME;
/** 类型名*/
@property (nonatomic, strong) NSString *C_WJGSNAME;
/** 类型对应图片*/
@property (nonatomic, strong) NSString *C_WJGSPIC;
@property (nonatomic, strong) NSString *TSY;

/** <#注释#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
