//
//  MJKAddCheckAddressCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAddCheckAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
