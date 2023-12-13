//
//  MJKAddFlowSubTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListSubModel.h"

@interface MJKAddFlowSubTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *invalidLabel;
@property (weak, nonatomic) IBOutlet UIButton *invalidButton;
@property (nonatomic, copy) void(^backFlowShopBlock)(NSString *str);

- (void)updatePhoneCell:(NSString *)str; //电话设置
- (void)updateEditPhoneCell:(MJKClueListSubModel *)model;//电话设置编辑
@end
