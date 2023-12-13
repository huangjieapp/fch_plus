//
//  MJKApprovalRequest.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/6.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKApprovalRequest : NSObject
+ (void)HttpApprovalRequestWithC_OBJECT_ID:(NSString *)C_OBJECT_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andSuccessBlock:(void(^)(void))completeBlock;
@end

NS_ASSUME_NONNULL_END
