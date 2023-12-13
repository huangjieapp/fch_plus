//
//  MJKNewWorkReportCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKPKModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKNewWorkReportCell : UITableViewCell
/** MJKPKModel*/
@property (nonatomic, strong) MJKPKModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
