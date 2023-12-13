//
//  MJKMRRemarkCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKMRRemarkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** 返回文字*/
@property (nonatomic, copy) void(^changeBlock)(NSString *str);
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;
/** 开始编辑*/
@property (nonatomic, copy) void(^beginBlock)(void);
/** 结束编辑*/
@property (nonatomic, copy) void(^endBlock)(void);
/** 开始长按*/
@property (nonatomic, copy) void(^beginLongBlock)(void);
/** 结束长按*/
@property (nonatomic, copy) void(^endLongBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
