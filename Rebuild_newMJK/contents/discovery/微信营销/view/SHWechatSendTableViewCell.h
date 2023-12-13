//
//  SHWechatSendTableViewCell.h
//  mcr_sh_master
//
//  Created by Hjie on 2017/8/24.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHWechatSendTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *receiveLabel;
@property (nonatomic, strong) UILabel *receiveLeftLabel;
@property (nonatomic, strong) UIImageView *receiveImageView;
@property (nonatomic, strong) UIView *receiveView;
@property (nonatomic, strong) UILabel *receiveTimeLabel;

- (void)initReceiveCellWithPhoto:(NSString *)image andContent:(NSString *)str andType:(NSString *)type andTime:(NSString *)time;
- (void)initSendCellWithPhoto:(NSString *)image andContent:(NSString *)str andType:(NSString *)type andTime:(NSString *)time;

+(CGFloat)getHeight:(NSDictionary*)dict;

@end
