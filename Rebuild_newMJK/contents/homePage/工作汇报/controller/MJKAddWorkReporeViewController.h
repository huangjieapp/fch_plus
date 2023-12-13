//
//  MJKAddWorkReporeViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/5.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAddWorkReporeViewController : DBBaseViewController
/** 编辑状态*/
@property (nonatomic, strong) NSString *editStr;
/** 员工id*/
@property (nonatomic, strong) NSString *USERID;
/** create time*/
@property (nonatomic, strong) NSString *createTime;
/** 是否新增工作圈*/
@property (nonatomic, assign) BOOL isAddWorkWorld;

@end
