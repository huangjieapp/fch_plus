//
//  MJKTelephoneRobotModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRobotModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_NAME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_SOURCE_DD_NAME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *D_START_TIME;
/** <#注释#>*/
@property (nonatomic, strong) NSString *bill;
/** <#注释#>*/
@property (nonatomic, strong) NSString *intentionDesc;
/** <#注释#>*/
@property (nonatomic, strong) NSString *number;

/** 话术模板id*/
@property (nonatomic, strong) NSString *nlpEventId;
/** 话术模板名称*/
@property (nonatomic, strong) NSString *nlpEventName;
/** 呼叫任务数*/
@property (nonatomic, strong) NSString *I_NUMBER;

/** 挂断原因*/
@property (nonatomic, strong) NSString *daStr;




@end

NS_ASSUME_NONNULL_END
