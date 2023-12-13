//
//  ServiceTaskAddViewController.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/27.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCOrderDetailModel.h"

#import "ServiceTaskDetailModel.h"

@interface ServiceTaskAddViewController : DBBaseViewController
/** 订单*/
@property (nonatomic, strong) NSString *vcStr;
//@property (nonatomic, strong) CGCOrderDetailModel *detailModel;
@property (nonatomic, strong) NSString *C_ID;//订单
//客户进入任务传值
@property (nonatomic, strong) ServiceTaskDetailModel *detailModel;
@property (nonatomic, strong) NSString *C_A42000_C_ID;

@property (nonatomic, copy) void(^reloadBlock)(void);
/** 返回任务id*/
@property (nonatomic, copy) void(^backC_A01200_C_IDBlock)(NSDictionary *C_A01200_C_ID);

@end
