//
//  MJKMessagePushNotiViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKMessagePushNotiViewController : DBBaseViewController
/** <#注释#>*/
@property (nonatomic, strong) NSString *titleNameXCX;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A41500_C_ID;
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** C_ID*/
@property (nonatomic, strong) NSString *C_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSDictionary *dataDic;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
/** 返回后的事件*/
@property (nonatomic, copy) void(^backActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
