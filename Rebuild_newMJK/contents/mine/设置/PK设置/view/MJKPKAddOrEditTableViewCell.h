//
//  MJKPKAddOrEditTableViewCell.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKPKAddOrEditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightLayout;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UIButton *addGroupImageButton;
@property (nonatomic, copy) void(^backTextFieldTextBlock)(NSString *str);
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
