//
//  ZhanbaiChooseTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/19.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhanbaiChooseTableViewCell : UITableViewCell

@property(nonatomic,strong)NSString*titleStr;
//选择的按钮 0否  1是
@property(nonatomic,assign)NSInteger number;

@property (weak, nonatomic) IBOutlet UIButton *falseButton;
@property (weak, nonatomic) IBOutlet UIButton *tureButton;
//0 否   1是
@property(nonatomic,copy)void(^clickSelectedButtonBlock)(NSInteger number);


@end
