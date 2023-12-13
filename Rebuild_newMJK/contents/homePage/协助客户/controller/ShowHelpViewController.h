//
//  ShowHelpViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowHelpViewController : UIViewController

/** <#注释#>*/
@property (nonatomic, strong) NSString *assistStr;
/** controller name*/
@property (nonatomic, strong) NSString *vcName;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_A41500_C_ID;//潜客id
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, copy) void(^backSelectParameterBlock)(NSString *codeStr, NSString *nameStr);
@property (nonatomic, strong) NSString *C_DESIGNER_ROLEID;//设计师

@end
