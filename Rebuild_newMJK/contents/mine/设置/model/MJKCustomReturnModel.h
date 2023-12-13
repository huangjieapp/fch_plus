//
//  MJKCustomReturnModel.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJKCustomReturnModel : MJKBaseModel
@property (nonatomic, strong) NSArray *content;
@property (nonatomic, strong) NSArray *list;

//业绩
@property (nonatomic, strong) NSString *C_ID;

@property (nonatomic, strong) NSString *I_A41500_NUMBER;//潜客目标量
@property (nonatomic, strong) NSString *I_A41600_NUMBER;//跟进目标量
@property (nonatomic, strong) NSString *I_A42000_NUMBER;//订单交付
@property (nonatomic, strong) NSString *I_A41600_YUYUENUMBER;//预约目标量
@property (nonatomic, strong) NSString *I_A41300_CLUENUMBER;//线索目标量
@property (nonatomic, strong) NSString *B_YGJEMB;//预估金额目标量
@property (nonatomic, strong) NSString *B_SJHKMB;//实际回款目标量

@property (nonatomic, strong) NSString *I_A42000INSERT_NUMBER;//订单新增
@end
