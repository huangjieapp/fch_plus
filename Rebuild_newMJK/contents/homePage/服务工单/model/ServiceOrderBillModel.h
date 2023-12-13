//
//  ServiceOrderBillModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/11/2.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductInfoModel.h"

@interface ServiceOrderBillModel : MJKBaseModel
@property(nonatomic,strong)NSString*allTotal;
@property(nonatomic,strong)NSString*pjTotal;
@property(nonatomic,strong)NSString*qtTotal;
@property(nonatomic,strong)NSArray*pjContent;
@property(nonatomic,strong)NSArray*qtContent;


@end


//allTotal = "0.00";
//pjContent =         (
//);
//pjTotal = "0.00";
//qtContent =         (
//);
//qtTotal = "0.00";
