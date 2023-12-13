//
//  ServiceOrderModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceOrderSubModel.h"

@interface ServiceOrderModel : MJKBaseModel
@property(nonatomic,strong)NSString*total;
@property(nonatomic,strong)NSArray*content;


@end
