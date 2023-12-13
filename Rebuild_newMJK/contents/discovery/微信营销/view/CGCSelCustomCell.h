//
//  CGCSelCustomCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCSellModel;
@interface CGCSelCustomCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *countLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCellWithModel:(CGCSellModel *)model;

@end
