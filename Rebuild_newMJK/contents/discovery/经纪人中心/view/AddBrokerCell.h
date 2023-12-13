//
//  AddBrokerCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/18.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBrokerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightLayout;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UILabel *mustBeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UILabel *desLab;

@property (weak, nonatomic) IBOutlet UITextField *desText;

@property (weak, nonatomic) IBOutlet UIImageView *img;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
