//
//  MJKCheckingCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKCheckingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
