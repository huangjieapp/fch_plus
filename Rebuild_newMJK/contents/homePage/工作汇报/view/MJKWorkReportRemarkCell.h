//
//  MJKWorkReportRemarkCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKWorkReportRemarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayout;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
