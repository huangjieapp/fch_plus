//
//  MJKWorkWorldListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MJKWorkWorldObjectMapModel;
@class MJKWorkWorldListCell;

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldListModel : MJKBaseModel
@property (nonatomic, strong) NSString *vcName;
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_LATITUDE;
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_LONGITUDE;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_ADDRESS;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_HEADIMGURL;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_OBJECTID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *D_CREATE_TIME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *OUTDATED;
/** <#备注#>*/
@property (nonatomic, strong) NSString *USER_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *USER_NAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_REMARK;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_REMINDING;
/** <#备注#>*/
@property (nonatomic, strong) NSString *comments;
/** <#备注#>*/
@property (nonatomic, strong) NSString *fabulous;
/** <#备注#>*/
@property (nonatomic, strong) NSString *fabulous_flag;
//X_REMINDINGNAME
@property (nonatomic, strong) NSString *X_REMINDINGNAME;
/** <#备注#>*/
@property (nonatomic, strong) MJKWorkWorldObjectMapModel *objectMap;
/** <#备注#>*/
@property (nonatomic, strong) NSArray *urlList;

/** <#注释#>*/
@property (nonatomic, assign) CGFloat cellheight;
/** <#注释#>*/
@property (nonatomic, strong) MJKWorkWorldListCell *cell;

/** <#注释#>*/
@property (nonatomic, strong) NSString *detailStr;

@end

NS_ASSUME_NONNULL_END
