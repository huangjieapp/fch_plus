//
//  ServiceTaskDetailHeaderTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/30.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTaskDetailHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property(nonatomic,copy)void(^clickTopThreeButtonBlock)(NSInteger index);   //0  1  2

//3个图片按钮
@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end
