//
//  MJKFlowDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowDetailModel.h"

typedef enum : NSUInteger {
	ChooseTableViewTypeCustomerSource,
	ChooseTableViewTypeAction,
	ChooseTableViewTypeStay,
} ChooseTableViewType;

@interface MJKFlowDetailTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, copy) void (^backTextBlock)(NSString *str);
- (void)updateCell:(NSArray *)titleArr andModel:(MJKFlowDetailModel *)model andRow:(NSInteger)row;//展厅流量
- (void)updateDetailCell:(NSArray *)titleArr andModel:(MJKFlowDetailModel *)model andRow:(NSInteger)row;//电话流量
- (void)updatePhoneCell:(NSString *)title andContent:(NSString *)str;//电话设置
- (void)addPhoneCell:(NSArray *)title andRow:(NSInteger)row;
/** <#备注#>*/
@property (nonatomic, assign) ChooseTableViewType type;
/** chooseBlock*/
@property (nonatomic, copy) void(^chooseBlock)(NSString *title, NSString *indexStr);
@end
