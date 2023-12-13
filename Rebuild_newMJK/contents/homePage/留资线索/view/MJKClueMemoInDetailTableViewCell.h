//
//  MJKClueMemoInDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJKClueMemoInDetailTableViewCellDelegate <NSObject>

@optional
- (void)scrollLastCell;

@end

@interface MJKClueMemoInDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;
@property (nonatomic, weak) id<MJKClueMemoInDetailTableViewCellDelegate>delegate;
@property (nonatomic, copy) void(^backTextViewBlock)(NSString *str);
//键盘出来 view 上升
@property(nonatomic,copy)void(^KeyBoardBlock)(UITextView*textView);


@end
