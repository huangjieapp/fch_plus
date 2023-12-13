//
//  AddHelperViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddHelperViewController : DBBaseViewController
/** <#注释#>*/
@property (nonatomic, strong) NSString *isAllHepler;
/** <#备注#>*/

@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, strong) NSString *C_A41500_C_ID;//潜客id
@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSString *vcName;
@property (nonatomic, copy) void(^userBlock)(NSString *nameStr, NSString *codeStr);
@property (nonatomic, strong) NSString *C_DESIGNER_ROLEID;//设计师
@property (nonatomic, strong) NSString *helpName;//设计师

/** <#注释#>*/
@property (nonatomic, strong) NSString *editStr;
@end
