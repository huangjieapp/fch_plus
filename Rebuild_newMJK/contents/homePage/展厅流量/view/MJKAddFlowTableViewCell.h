//
//  MJKAddFlowTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAddFlowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLayout;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleTextFieldLayout;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *peopleNumberTextField;
@property (nonatomic, strong) void(^backTextBlock)(NSString *str);
- (void)updateCustomCell:(NSString *)customReturnStr andDays:(NSString *)day andDetail:(BOOL)isDetail;//设置页面使用
@end
