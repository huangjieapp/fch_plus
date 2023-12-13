//
//  MJKApprovalHistoryModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/3/4.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKApprovalHistoryModel : MJKBaseModel
/** <#注释#> */
@property (nonatomic,strong) NSString *avatar;

@property (nonatomic,strong) NSString *C_ID;
@property (nonatomic,strong) NSString *C_APPROVAL_ID;
@property (nonatomic,strong) NSString *C_APPROVAL_NAME;
@property (nonatomic,strong) NSString *C_STATUS_DD_ID;
@property (nonatomic,strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic,strong) NSString *D_LASTUPDATE_TIME;
@property (nonatomic,strong) NSString *X_REMARK;
@property (nonatomic,strong) NSString *C_A42500_C_ID;
@end

NS_ASSUME_NONNULL_END
