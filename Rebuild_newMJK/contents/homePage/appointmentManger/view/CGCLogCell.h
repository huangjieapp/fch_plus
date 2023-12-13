//
//  CGCLogCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/1.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKOrderMoneyListModel.h"
@class CGCLogModel;
@class MJKAdditionalTrackModel;


@interface CGCLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *morePlanButton;
/** <#注释#>*/
@property (nonatomic, strong) MJKAdditionalTrackModel *additionalModel;

/** MJKHistoryModel*/
@property (nonatomic, strong) CGCLogModel *clueHistoryModel;
@property (weak, nonatomic) IBOutlet UIButton *planButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *datelab;
@property (weak, nonatomic) IBOutlet UIButton *showDetailViewButton;
@property (weak, nonatomic) IBOutlet UIButton *showDetailButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusRightLayout;

@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonSepView;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@property (nonatomic, copy) void(^detailButtonClickBlock)(void);
@property (nonatomic, copy) void(^memoViewBlock)(void);
@property (nonatomic, copy) void(^planButtonActionBlock)(void);
@property (nonatomic, copy) void(^morePlanButtonActionBlock)(void);
@property (nonatomic, copy) void(^completeButtonActionBlock)(void);
@property (nonatomic, copy) void(^showDetailButtonActionBlock)(void);
@property (weak, nonatomic) IBOutlet UIImageView *trajectoryImg;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCellWithModel:(CGCLogModel *)model;
- (void)reloadOrderCellWithModel:(MJKOrderMoneyListModel *)model andType:(NSString *)type andRow:(NSInteger)row;


@end
