//
//  ApprolDeatilTableViewCell.h
//  mcr_s
//
//  Created by bipyun on 16/6/12.
//  Copyright © 2016年 match. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprolDeatilTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rejectedLabel;
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong, nonatomic) IBOutlet UIButton *disagreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *ImgViewLabel;

@property (strong, nonatomic) IBOutlet UILabel *shenqinName;
@property (strong, nonatomic) IBOutlet UILabel *statuesLabel;
@property (strong, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIView *view_line;
@property (strong, nonatomic) IBOutlet UIImageView *imgStatues;
@property (strong, nonatomic) IBOutlet UIImageView *btnbohui;
@property (strong, nonatomic) IBOutlet UIImageView *btntongyi;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIView *bavkeview;
@property (strong, nonatomic) IBOutlet UILabel *remark;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIView *contentview;
@property (weak, nonatomic) IBOutlet UILabel *carLabel;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;


@end
