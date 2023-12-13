//
//  VerificationDetailVC.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DBBaseViewController.h"

typedef void(^HXBLOCK)(void);
@class PointorderModel;

@interface VerificationDetailVC : DBBaseViewController

@property (nonatomic, strong) PointorderModel  *pModel;

@property (nonatomic, copy) HXBLOCK hxBlock;


@end
