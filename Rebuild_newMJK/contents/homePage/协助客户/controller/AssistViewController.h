//
//  AssistViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/5.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistViewController : DBBaseViewController
/** tabSearchStr*/
@property (nonatomic, strong) NSString *tabSearchStr;
/** <#备注#>*/
@property (nonatomic, assign) BOOL isTab;
@property (nonatomic, strong) NSString *CREATE_TIME_TYPE;
@property (nonatomic, strong) NSString *CREATE_TIME;
@property (nonatomic, strong) NSString *FOLLOW_TIME_TYPE;
@property (nonatomic, strong) NSString *TYPE;
@property (nonatomic, strong) NSString *XZCREATE_TIME_TYPE;
/** 客户中心*/
@property(nonatomic,strong) NSString *saleCode;
/** <#备注#>*/
@property (nonatomic, strong) NSString *assistStr;
@end
