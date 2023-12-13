//
//  MJKNewAddDealViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/10.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCOrderDetailModel;
@class MJKOrderMoneyListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKNewAddDealViewController : UIViewController
/** orderDetailModel*/
@property (nonatomic, strong) CGCOrderDetailModel *orderDetailModel;
/** MJKOrderMoneyListModel*/
@property (nonatomic, strong) MJKOrderMoneyListModel *model;
/** vcName*/
@property (nonatomic, strong) NSString *vcName;
@end

NS_ASSUME_NONNULL_END
