//
//  MJKFlowNoFlie.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKFlowNoFlie : NSObject
+ (void)HTTPUpdateFlowWithC_ID:(NSString *)C_ID andRemark:(NSString *)REMARKStr andShopType:(NSString *)C_REMARK_TYPE_DD_ID andBlock:(void(^)(void))completeBlock;

+ (void)updateAssignFlow:(NSString *)chooseStr andSale:(NSString *)userId andC_ID:(NSString *)C_ID;

@end
