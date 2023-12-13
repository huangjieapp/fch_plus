//
//  MJKMaterialListType0TableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKMaterialListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKMaterialNinePhotoTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^shareButtonActionBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** MJKMaterialListModel*/
@property (nonatomic, strong) MJKMaterialListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)heightForCellWithModel:(MJKMaterialListModel *)model;
@end

NS_ASSUME_NONNULL_END
