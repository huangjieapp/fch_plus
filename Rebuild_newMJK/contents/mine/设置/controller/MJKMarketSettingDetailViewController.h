//
//  MJKMarketSettingDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKMarketSubModel.h"
#import "MJKPhoneSetListSaleModel.h"

@interface MJKMarketSettingDetailViewController : UIViewController
@property (nonatomic, strong) MJKMarketSubModel *model;
@property (nonatomic, strong) MJKPhoneSetListSaleModel *phoneModel;
@end
