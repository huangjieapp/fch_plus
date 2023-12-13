//
//  MJKFileTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/7.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKFileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
