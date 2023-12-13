//
//  MJKHomePageTodoCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKPendingModel.h"

@interface MJKHomePageTodoNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
/** root vc*/
@property (nonatomic, weak) UIViewController *rootVC;
/** 状态*/
@property (nonatomic, strong) NSString *typeStr;
/** todo data*/
@property (nonatomic, strong) NSArray *todoArray;
@property (weak, nonatomic) IBOutlet UIButton *toSetButton;
+ (CGFloat)cellHeightTodoArray:(NSArray	*)array;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
