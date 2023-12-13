//
//  MJKFlowNoFlie.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKFlowNoFlie.h"

@implementation MJKFlowNoFlie
+ (void)HTTPUpdateFlowWithC_ID:(NSString *)C_ID andRemark:(NSString *)REMARKStr andShopType:(NSString *)C_REMARK_TYPE_DD_ID andBlock:(void(^)(void))completeBlock{
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:@{@"C_ID" : C_ID, @"USER_ID" : [NewUserSession instance].user.u051Id, @"TYPE" : @"0", @"X_REMARK" : REMARKStr.length > 0 ? REMARKStr : @"", @"C_REMARK_TYPE_DD_ID" : C_REMARK_TYPE_DD_ID} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			
			if (completeBlock) {
				completeBlock();
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

+ (void)updateAssignFlow:(NSString *)chooseStr andSale:(NSString *)userId andC_ID:(NSString *)C_ID {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:@{@"C_ID" : C_ID.length > 0 ? C_ID : chooseStr, @"USER_ID" : userId, @"TYPE" : @"4"} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"msg"]];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}
@end
