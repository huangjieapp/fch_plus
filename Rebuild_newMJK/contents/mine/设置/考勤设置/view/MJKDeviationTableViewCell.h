//
//  MJKDeviationTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/13.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKDeviationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *meterLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
