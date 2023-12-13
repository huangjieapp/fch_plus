//
//  MJKAuditRecordsModel.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAuditRecordsModel : MJKBaseModel
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_APPROVAL_NAME;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *D_LASTUPDATE_TIME;
@property (nonatomic, strong) NSString *X_AGREE;
@end

NS_ASSUME_NONNULL_END
