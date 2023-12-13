//
//  MJKHttpApproval.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/9/11.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKHttpApproval : NSObject
+(void)DefeatGetHttpValuesWithC_VOUCHERID:(NSString *)C_VOUCHERID andX_REMARK:(NSString *)X_REMARK andC_REMARK_TYPE_DD_ID:(NSString *)C_REMARK_TYPE_DD_ID andC_OBJECT_ID:(NSString *)C_OBJECT_ID andTYPE:(NSString *)TYPE andSuccessBlock:(void(^)(void))completeBlock;

+ (void)DefeatGetHttpValuesWithObjectId:(NSString *)C_OBJECT_ID andX_REMARK:(NSString *)X_REMARK andC_REMARK_TYPE_DD_ID:(NSString *)C_REMARK_TYPE_DD_ID andSuccessBlock:(void(^)(void))completeBlock;
@end

NS_ASSUME_NONNULL_END
