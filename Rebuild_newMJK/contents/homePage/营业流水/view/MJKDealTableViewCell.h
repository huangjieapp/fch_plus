//
//  MJKDealTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/3/30.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKDealTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
