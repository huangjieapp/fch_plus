//
//  MJKGroupPeopleTableViewCell.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKPKGroupPeopleModel.h"
#import "MJKPKModel.h"


@interface MJKGroupPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, strong) MJKPKGroupPeopleModel *model;
@property (nonatomic, strong) MJKPKGroupPeopleModel *workModel;
@property (nonatomic, strong) MJKPKModel *PKModel;
@property (weak, nonatomic) IBOutlet UIButton *didSelectButton;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
