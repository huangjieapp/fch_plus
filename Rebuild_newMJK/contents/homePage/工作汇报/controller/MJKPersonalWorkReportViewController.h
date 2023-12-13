//
//  MJKPersonalWorkReportViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/5.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKWorkReportListModel.h"

@interface MJKPersonalWorkReportViewController : UIViewController
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 员工id*/
@property (nonatomic, strong) NSString *USERID;
/** create time*/
@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *headImage;

@property (nonatomic, strong) NSString *userName;
/** */
@property (nonatomic, strong) MJKWorkReportListModel *listModel;

@end
