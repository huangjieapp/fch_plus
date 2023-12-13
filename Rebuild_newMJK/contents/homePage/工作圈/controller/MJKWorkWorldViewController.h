//
//  MJKWorkWorldViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldViewController : UIViewController

/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** usetid*/
@property (nonatomic, strong) NSString *userID;
/** 筛选条件：类型
 全部:不传
 传0不取日报类型
 日报：A49000_C_TYPE_0000
 打卡：A49000_C_TYPE_0001*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** */
@property (nonatomic, strong) NSString *name;
@end

NS_ASSUME_NONNULL_END
