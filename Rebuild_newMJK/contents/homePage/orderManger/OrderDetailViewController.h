//
//  OrderDetailViewController.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//


#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>

typedef void(^RELOADBLOCK)();

@interface OrderDetailViewController : DBBaseViewController<MFMessageComposeViewControllerDelegate>

@property (nonatomic,copy) NSString * isEdit;//订单状态

@property(nonatomic,strong)NSString *URL;
/** rootVC*/
@property (nonatomic, weak) UIViewController *rootVC;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *statusType;//状态类型

@property(nonatomic,copy)RELOADBLOCK reloadBlock;
@end
