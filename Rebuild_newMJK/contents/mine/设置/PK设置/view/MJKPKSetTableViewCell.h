//
//  MJKPKSetTableViewCell.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKPKSetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
