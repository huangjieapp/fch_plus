//
//  MJKOrderRecordTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKOrderRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
