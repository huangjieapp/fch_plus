//
//  MJKAddFlowShopTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/8.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAddFlowShopTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UILabel *randomLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^backFlowShopBlock)(NSString *str);
@property (weak, nonatomic) IBOutlet UIButton *invalidButton;
@property (weak, nonatomic) IBOutlet UILabel *invalidLabel;

@end
