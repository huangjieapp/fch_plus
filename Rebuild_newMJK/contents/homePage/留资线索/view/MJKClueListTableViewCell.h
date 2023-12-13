//
//  MJKClueListTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListMainSecondModel.h"

@interface MJKClueListTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *againImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameImageLayout;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;
@property (weak, nonatomic) IBOutlet UILabel *custFirstName;
@property (weak, nonatomic) IBOutlet UIImageView *custSexImageView;
@property (weak, nonatomic) IBOutlet UILabel *sendDowntime;
@property (weak, nonatomic) IBOutlet UILabel *custName;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *approachLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepLabelLayoutConstraint;
@property (nonatomic, assign) BOOL isAgain;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

- (void)updateCellWithDatas:(MJKClueListMainSecondModel *)model;

@end
