//
//  MJKPhoneSetListModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/14.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKPhoneSetListModel : MJKBaseModel

@property (nonatomic, strong) NSArray *content;

@property (nonatomic, strong) NSString *C_A41200_C_ID;
@property (nonatomic, strong) NSString *C_A41200_C_NAME;//话机来源
@property (nonatomic, strong) NSString *C_INTERNAL;//话机号码
@end
