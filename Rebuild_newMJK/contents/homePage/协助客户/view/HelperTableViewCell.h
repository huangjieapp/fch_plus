//
//  HelperTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
