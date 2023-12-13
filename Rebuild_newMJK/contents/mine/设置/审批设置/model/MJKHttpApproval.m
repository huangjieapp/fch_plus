//
//  MJKHttpApproval.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/9/11.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKHttpApproval.h"

@implementation MJKHttpApproval
+(void)DefeatGetHttpValuesWithC_VOUCHERID:(NSString *)C_VOUCHERID andX_REMARK:(NSString *)X_REMARK andC_REMARK_TYPE_DD_ID:(NSString *)C_REMARK_TYPE_DD_ID andC_OBJECT_ID:(NSString *)C_OBJECT_ID andTYPE:(NSString *)TYPE andSuccessBlock:(void(^)(void))completeBlock
{
    
    NSMutableDictionary *contentDic = [NSMutableDictionary  dictionary];
    if (C_OBJECT_ID.length > 0) {
        [contentDic setObject:C_OBJECT_ID forKey:@"C_OBJECT_ID"];
    }
    if (TYPE.length > 0) {
        [contentDic setObject:TYPE forKey:@"C_TYPE_DD_ID"];
    }
    if (X_REMARK.length > 0) {
        [contentDic setObject:X_REMARK forKey:@"X_REMARK"];
    }
    if (C_REMARK_TYPE_DD_ID.length > 0) {
        [contentDic setObject:C_REMARK_TYPE_DD_ID forKey:@"C_REMARK_TYPE_DD_ID"];
    }
    if (C_VOUCHERID.length > 0) {
        [contentDic setObject:C_VOUCHERID forKey:@"C_VOUCHERID"];
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a425/initiateApproval", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
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

+ (void)DefeatGetHttpValuesWithObjectId:(NSString *)C_OBJECT_ID andX_REMARK:(NSString *)X_REMARK andC_REMARK_TYPE_DD_ID:(NSString *)C_REMARK_TYPE_DD_ID andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (C_OBJECT_ID.length > 0) {
        contentDic[@"C_OBJECT_ID"] = C_OBJECT_ID;
    }
    contentDic[@"C_TYPE_DD_ID"] = @"A42500_C_TYPE_0000";
    //转出备注
    if (X_REMARK.length > 0) {
        contentDic[@"X_REMARK"] = X_REMARK;
    }
    
    if (C_REMARK_TYPE_DD_ID.length > 0) {
        contentDic[@"C_REMARK_TYPE_DD_ID"] = C_REMARK_TYPE_DD_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a425/initiateApproval", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
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


@end
