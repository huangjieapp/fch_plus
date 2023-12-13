//
//  ServiceTaskModel.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceTaskSubModel.h"

@interface ServiceTaskModel : MJKBaseModel

@property(nonatomic,strong)NSArray*content;
@property(nonatomic,strong)NSString*total;

@end
