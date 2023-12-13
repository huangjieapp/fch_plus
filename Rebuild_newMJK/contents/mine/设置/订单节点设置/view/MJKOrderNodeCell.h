//
//  MJKOrderNodeCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/12.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKOrderMoneyListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKOrderNodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signLeftLayout;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 交换位置*/
@property (nonatomic, copy) void(^exchangeObjectBlock)(NSString *name);
/** 新增节点*/
@property (nonatomic, copy) void(^addObjectBlock)(void);
/** 编辑节点*/
@property (nonatomic, copy) void(^editObjectBlock)(NSString *name);
/** MJKOrderMoneyListModel*/
@property (nonatomic, strong) MJKOrderMoneyListModel *model;
@end

NS_ASSUME_NONNULL_END
