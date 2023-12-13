//
//  SHWechatMarketTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHWechatListSubModel.h"

@interface SHWechatMarketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *topStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomStatusLabel;

@property (nonatomic, strong) NSString *isC_CLZT;
@property (nonatomic, strong) NSString *isC_STAR;
@property (nonatomic, strong) NSString *isSex;

@property (nonatomic, strong) SHWechatListSubModel *wechatListSubModel;

- (void)updateCellWithData:(SHWechatListSubModel *)wechatListSubModel;

@end
