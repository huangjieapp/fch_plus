//
//  HttpWebObject.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/13.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "HttpWebObject.h"

@implementation HttpWebObject

//星标接口
+(void)setStarStatusWithStarID:(NSString*)starID andCustomerID:(NSString*)customerID success:(void(^)(id data))successBlock{
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/updateStar", HTTP_IP] parameters:@{@"C_ID":customerID,@"C_STAR_DD_ID":starID} compliation:^(id data, NSError *error) {
        if (successBlock) {
            successBlock(data);
        }
        
        
        
    }];

    
    
}




//重新指派潜客    salerIDS 潜客的ids  多个就用，隔开
+(void)AssignCustomerToSaleWithSalerID:(NSString*)salerID andCustomerIDS:(NSString*)customerIDS success:(void(^)(id data))successBlock{
    NSDictionary*contentDict=@{@"C_ID":customerIDS,@"USER_ID":salerID};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/assign", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if (successBlock) {
            successBlock(data);
        }
        
        
    }];
  
}


//重新指派服务任务    salerIDS 潜客的ids  多个就用，隔开
+(void)AssignServiceTaskToSaleWithSalerID:(NSString*)salerID andServiceIDS:(NSString*)ServiceIDS success:(void(^)(id data))successBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_MuchAssign];
    NSDictionary*contentDict=@{@"C_ID":ServiceIDS,@"USER_ID":salerID};
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if (successBlock) {
            successBlock(data);
        }
        
        
    }];
    
}



+(void)HttpObjectGetMarketActionWithSourceID:(NSString*)sourceID Success:(void(^)(id data))successBlock{
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    if (sourceID.length>0) {
         [contentDict setObject:sourceID forKey:@"C_CLUESOURCE_DD_ID"];
    }
    contentDict[@"C_TYPE_DD_ID"] = @"A41200_C_TYPE_0000";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if (successBlock) {
            successBlock(data);
        }
    }];

    
    
}

+ (void)getNoteDataCompliation:(void(^)(id data))noteDatasBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46700WebService-getAllList"];
    
    [dict setObject:@{} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (noteDatasBlock) {
                noteDatasBlock(data);
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}



@end
