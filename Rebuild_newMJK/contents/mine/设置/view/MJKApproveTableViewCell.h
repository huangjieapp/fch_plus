//
//  MJKApproveTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKAppoveModel.h"

@interface MJKApproveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (nonatomic, copy) void(^backBoolBlock)(NSString *str);
- (void)updataCellWithTitle:(NSString *)title andRow:(NSInteger)row andModel:(MJKAppoveModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
