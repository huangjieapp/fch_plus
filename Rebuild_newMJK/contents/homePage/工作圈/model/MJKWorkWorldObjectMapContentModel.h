//
//  MJKWorkWorldObjectMapContentModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldObjectMapContentModel : MJKBaseModel
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_TOTAL;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_NAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *UNIT;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_OBJECTIDS;
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_TOTAL_JH;
/** <#备注#>*/
@property (nonatomic, strong) NSString *X_REMARK;

/** <#备注#>*/
@property (nonatomic, strong) NSString *I_TARGETNUMBER;
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_TOTAL_JH_MR;
/** <#备注#>*/
@property (nonatomic, strong) NSString *B_TOTAL_BY;


@property (nonatomic, strong) NSString *B_AMOUNT;

/** <#备注#>*/
@property (nonatomic, strong) NSString *C_VOUCHERID;
/** <#备注#>*/
@property (nonatomic, strong) NSString *C_VOUCHERNAME;
/** <#备注#>*/
@property (nonatomic, strong) NSString *I_YCS;
/** <#备注#>*/
@property (nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
