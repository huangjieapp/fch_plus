//
//  MJKProductCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKProductCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectProductButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLaebl;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 点击事件*/
@property (nonatomic, copy) void(^clickLikeProductActionBlock)(void);
@end
