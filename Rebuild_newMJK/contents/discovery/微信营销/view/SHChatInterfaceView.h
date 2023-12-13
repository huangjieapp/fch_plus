//
//  SHChatInterfaceView.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHWechatListSubModel.h"

@interface SHChatInterfaceView : UIView
@property (weak, nonatomic) IBOutlet UIButton *NewCustBtn;
@property (weak, nonatomic) IBOutlet UIButton *AssCustBtn;
@property (weak, nonatomic) IBOutlet UIImageView *custImageView;
@property (weak, nonatomic) IBOutlet UILabel *custNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLoginLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanningChannelsLabel;
@property (weak, nonatomic) IBOutlet UIButton *startState;
@property (weak, nonatomic) IBOutlet UITextField *memoLabel;
@property (nonatomic, strong) SHWechatListSubModel *wechatListSubModel;
@property (nonatomic, strong) UIViewController *rootVC;

//175的高
+(instancetype)chatInterfaceView;


@end
