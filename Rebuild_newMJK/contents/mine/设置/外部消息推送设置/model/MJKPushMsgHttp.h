//
//  MJKPushMsgHttp.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/11.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushMsgHttp : NSObject
+ (void)pushInfoWithC_A41500_C_ID:(NSString *)C_A41500_C_ID andC_ID:(NSString *)C_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andVC:(UIViewController *)vc andYesBlock:(void(^)(NSDictionary *data))yesBlock andNoBlock:(void(^)(void))noBlock;
@end

NS_ASSUME_NONNULL_END
