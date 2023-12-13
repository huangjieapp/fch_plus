//
//  MJKAddressTableViewCell.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseAreaLayout;
@property (weak, nonatomic) IBOutlet UIButton *chooseAreaButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) void(^changeTextBlock)(NSString *str);
@property (nonatomic, copy) void(^selectAreaBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)cellHeight;
@end
