//
//  CGCPersonInfoCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCPersonDetailInfoModel;
@interface CGCPersonInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLab;

@property (weak, nonatomic) IBOutlet UILabel *rightLab;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCell:(CGCPersonDetailInfoModel *)model withIndex:(NSInteger)index;
@end
