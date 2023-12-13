//
//  MJKApprovalRequest.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/6.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKApprovalRequest.h"

@implementation MJKApprovalRequest
+ (void)HttpApprovalRequestWithC_OBJECT_ID:(NSString *)C_OBJECT_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andSuccessBlock:(void(^)(void))completeBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (C_OBJECT_ID.length > 0) {
        contentDic[@"C_OBJECT_ID"] = C_OBJECT_ID;
    }
    if (C_TYPE_DD_ID.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMD425APPROVAL parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            if (completeBlock) {
                completeBlock();
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}
@end
