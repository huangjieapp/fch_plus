//
//  CGCDealListViewController.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
typedef void(^RELOADTABBLOCK)();
@interface CGCDealListViewController : UIViewController

@property (nonatomic,copy) NSString * orderId;

@property (nonatomic, copy) RELOADTABBLOCK tabBlock;

@property (nonatomic, copy) NSString *isEidt;
@end
