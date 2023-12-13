//
//  MJKOnlineHallTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowInstrumentSubModel.h"

@interface MJKOnlineHallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, copy) void(^backChangeTextBlock)(NSString *str);

@property (nonatomic, strong) MJKFlowInstrumentSubModel *model;
- (void)updataDetailTitle:(NSString *)title andModel:(MJKFlowInstrumentSubModel *)model andRow:(NSInteger)row;//详情
- (void)updataChangeCellTitle:(NSString *)title andModel:(MJKFlowInstrumentSubModel *)model andRow:(NSInteger)row;//修改

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
