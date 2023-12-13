//
//  MJKMarketSettingTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKMarketSetDetailModel.h"

@interface MJKMarketSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *editTextField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayout;
@property (nonatomic, copy) void(^backTextBlock)(NSString *str);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)updateCell:(NSString *)title andStatus:(NSString *)status;//列表
- (void)updateDetailCellWithTitle:(NSString *)title andDetailContent:(NSString *)content;//详情
- (void)updateEditCellWithTitle:(NSString *)title andDetailContent:(NSString *)content;//编辑
- (void)updateAddCellWithTitle:(NSString *)title andModel:(MJKMarketSetDetailModel *)model andRow:(NSInteger)row; //添加

- (void)updatePhoneCellWith:(NSString *)title andPhone:(NSString *)phone;//电话列表
@end
