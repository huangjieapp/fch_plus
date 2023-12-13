//
//  MJKHomePageJXModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKHomePageJXModel : MJKBaseModel
/** 完成率*/
@property (nonatomic, strong) NSString *WCL;
/** 本月目标*/
@property (nonatomic, strong) NSString *MB;
@property (nonatomic, strong) NSString *WC;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, strong) NSString *C_LOCNAME;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
/** 本月累计*/
@property (nonatomic, strong) NSString *MIDCOUNT;
/** 完成率FLAG*/
@property (nonatomic, strong) NSString *WCL_FLAG;
/** 今日新增*/
@property (nonatomic, strong) NSString *JRCOUNT;
/** 月环比*/
@property (nonatomic, strong) NSString *BL;
/** 月环比FLAG*/
@property (nonatomic, strong) NSString *FLAG;
/** 大类名称*/
@property (nonatomic, strong) NSString *NAME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *USERID;
/** TYPE*/
@property (nonatomic, strong) NSString *TYPE;


@property (nonatomic, strong) NSString *yyb;
@property (nonatomic, strong) NSString *jxb;
@property (nonatomic, strong) NSString *yqb;
@property (nonatomic, strong) NSString *gjb;
@end
