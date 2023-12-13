//
//  MJKOrderFllowViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/18.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGCOrderDetailModel.h"

@interface MJKOrderFllowViewController : DBBaseViewController
@property (nonatomic,strong) CGCOrderDetailModel * detailModel;
@property (nonatomic, strong) NSString *followText;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) NSString *isDetail;
@property (nonatomic, strong) NSString *objectID;//跟进id
@property (nonatomic, strong) NSString *orderID;//订单id
/** 提交成功返回*/
@property (nonatomic, strong) void(^backSubmitBlock)(void);
@end
