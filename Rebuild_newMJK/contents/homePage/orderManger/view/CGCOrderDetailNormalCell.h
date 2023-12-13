//
//  CGCOrderDetailNormalCell.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    CGCOrderDetailNormalCellDisplay,//正常展示
    CGCOrderDetailNormalCellEidt//编辑和新增

}CGCOrderDetailNormalCellStyle;

@interface CGCOrderDetailNormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *navImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightLayout;
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *sepView;
+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(CGCOrderDetailNormalCellStyle)type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewCenterLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewCenterLayOut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonCenterLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldCenterLayout;

@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

- (void)updateRow1Address;

@end
