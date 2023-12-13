//
//  HttpWebObject.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/13.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpWebObject : NSObject

//星标接口      客户id 和    A41500_C_STAR_0000设为星标      A41500_C_STAR_0001未星标
+(void)setStarStatusWithStarID:(NSString*)starID andCustomerID:(NSString*)customerID success:(void(^)(id data))successBlock;
//重新指派潜客    salerIDS 潜客的ids  多个就用，隔开
+(void)AssignCustomerToSaleWithSalerID:(NSString*)salerID andCustomerIDS:(NSString*)customerIDS success:(void(^)(id data))successBlock;
//重新指派服务任务    salerIDS 潜客的ids  多个就用，隔开
+(void)AssignServiceTaskToSaleWithSalerID:(NSString*)salerID andServiceIDS:(NSString*)ServiceIDS success:(void(^)(id data))successBlock;



//获取市场活动的数据
+(void)HttpObjectGetMarketActionWithSourceID:(NSString*)sourceID Success:(void(^)(id data))successBlock;
//客户标签
+ (void)getNoteDataCompliation:(void(^)(id data))noteDatasBlock;

@end
