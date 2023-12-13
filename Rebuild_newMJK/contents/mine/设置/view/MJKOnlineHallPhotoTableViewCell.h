//
//  MJKOnlineHallPhotoTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/18.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKOnlineHallPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic, copy) void(^backClickImageButtonBlock)(void);

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
