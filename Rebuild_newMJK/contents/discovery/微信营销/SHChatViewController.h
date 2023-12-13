//
//  SHChatViewController.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/31.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHWechatListSubModel.h"

@interface SHChatViewController : UIViewController

@property (nonatomic, strong) SHWechatListSubModel *wechatListSubModel;
@property (nonatomic, copy) void(^isLook)(BOOL isLook);

@end
