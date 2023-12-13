//
//  MJKWorkTomorrowTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkTomorrowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftLayout;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
