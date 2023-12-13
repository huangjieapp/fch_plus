//
//  MJKPersonAttendanceViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKMonthStatementsModel.h"

@interface MJKPersonAttendanceViewController : UIViewController
/** MJKWorkReportStatementsListModel*/
@property (nonatomic, strong) MJKMonthStatementsModel *listModel;
/** time str*/
@property (nonatomic, strong) NSString *timeStr;
@end
