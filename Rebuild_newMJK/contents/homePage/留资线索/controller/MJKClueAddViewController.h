//
//  MJKClueAddViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKClueAddViewController : DBBaseViewController

/** <#注释#>*/
@property (nonatomic, strong) NSString *vcName;

@property (nonatomic, copy) void(^backViewBlock)(NSString *str);

/** 经纪人*/
@property (nonatomic, strong) NSString *agentStr;
/** 经纪人*/
@property (nonatomic, strong) NSString *agentCode;
@end
