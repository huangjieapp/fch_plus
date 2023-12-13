//
//  MJKClueDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueDetailModel.h"

@interface MJKClueDetailTableViewCell : UITableViewCell
/** <#注释#>*/
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (nonatomic, strong) NSArray *titleArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepLabelRightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepLabelLeftLayout;
@property (weak, nonatomic) IBOutlet UIButton *phonePlayButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneCopyutton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressContentLabel;
@property (nonatomic, strong) NSString *vcname;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLayoutConstraint;
@property (nonatomic, strong) MJKClueDetailModel *clueDetailModel;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;  //tag

@property (nonatomic, copy) void(^backNameTextBlock)(NSString *str);
@property (nonatomic, copy) void(^backPhoneNumberTextBlock)(NSString *str);
@property (nonatomic, copy) void(^backProducrTextBlock)(NSString *str);
@property (nonatomic, copy) void(^backWeChatNumberBlock)(NSString *str);
//详情
- (void)updateCellWithDatas:(NSString *)model andTitle:(NSString *)str andRow:(NSInteger)row;
//添加时
- (void)updateCell:(NSInteger)row andTitleArray:(NSArray *)arr;
//展厅流量
- (void)updateFlowCell:(NSInteger)row;
//电话流量
- (void)updatePhoneFlowCell:(NSInteger)row andDetail:(BOOL)isDetail;
@end
