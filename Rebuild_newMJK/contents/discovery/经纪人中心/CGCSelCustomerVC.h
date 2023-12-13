//
//  CGCSelCustomerVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/6/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DBBaseViewController.h"

typedef void(^SELCUSBLOCK)();

@interface CGCSelCustomerVC : DBBaseViewController

@property (nonatomic, copy) NSString *B_GUIDEPRICE;

@property (nonatomic, copy) NSString *C_A41200_C_ID;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) SELCUSBLOCK selBlock;

@end
