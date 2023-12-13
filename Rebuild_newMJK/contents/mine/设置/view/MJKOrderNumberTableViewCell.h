//
//  MJKOrderNumberTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//


#pragma 作废


#import <UIKit/UIKit.h>

@interface MJKOrderNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (nonatomic, copy) void(^backTextBlock)(NSString *str);

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)updataCellTitle:(NSArray *)titleArr andContent:(NSArray *)contentArr andRow:(NSInteger)row;
@end
