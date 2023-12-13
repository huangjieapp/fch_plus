//
//  CGCPersonInfoVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBBaseViewController.h"
#import <MessageUI/MessageUI.h>
#import<MessageUI/MFMailComposeViewController.h>


@interface CGCPersonInfoVC : DBBaseViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>


@property (nonatomic, copy) NSString *C_ID;

@end
