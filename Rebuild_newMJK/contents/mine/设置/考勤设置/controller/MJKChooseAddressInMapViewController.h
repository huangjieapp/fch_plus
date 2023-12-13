//
//  MJKChooseAddressInMapViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/31.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKCheckDetailAddressModel.h"

@interface MJKChooseAddressInMapViewController : DBBaseViewController
/** select address back*/
@property (nonatomic, copy) void(^backAddressDicBlock)(NSDictionary *model);
/** detail dic*/
@property (nonatomic, strong) NSDictionary *haveAddressDic;
/** MJKCheckDetailAddressModel*/
@property (nonatomic, strong) MJKCheckDetailAddressModel *addressModel;

@end
