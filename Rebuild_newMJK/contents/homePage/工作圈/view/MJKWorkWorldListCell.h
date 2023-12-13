//
//  MJKWorkWorldListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKWorkWorldListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** MJKWorkWorldListModel*/
@property (nonatomic, strong) MJKWorkWorldListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightForCell:(MJKWorkWorldListModel *)model;
/** 点击放大图片*/
@property (nonatomic, copy) void(^clickBigImgeBlock)(UIImageView *imageView);
/** 点击展示全文或收起*/
@property (nonatomic, copy) void(^clickShowAllTextBlock)(BOOL isSelected);
/** 点击日报详情*/
@property (nonatomic, copy) void(^clickDetailWorkReportBlock)(NSIndexPath *reportIndexPath);
/** detailStr*/
@property (nonatomic, strong) NSString *detailStr;
/** 跳转到个人*/
@property (nonatomic, copy) void(^clickGotoPresonalBlock)(void);
/** 签到详情*/
@property (nonatomic, copy) void(^signDetailBlock)(void);
/** 点赞*/
@property (nonatomic, copy) void(^giveLikeButtonBlock)(void);
/** 评论*/
@property (nonatomic, copy) void(^commentButtonBlock)(void);
@end

NS_ASSUME_NONNULL_END
