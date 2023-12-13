//
//  MJKSettingListTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKSettingListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
