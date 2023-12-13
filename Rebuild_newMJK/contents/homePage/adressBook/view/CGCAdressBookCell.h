//
//  CGCAdressBookCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGCAdressBookDetailModel;
@interface CGCAdressBookCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *iconLab;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)reloadCell:(CGCAdressBookDetailModel*)model;
@end
