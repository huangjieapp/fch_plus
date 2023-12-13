//
//  MJKClueDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListMainSecondModel.h"
#import "CustomerDetailInfoModel.h"

@protocol MJKClueDetailViewControllerDelegate <NSObject>
//这个是用来 新增完潜客 钓完线索套潜客接口   之后 跳是否跟进接口的
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel*)newModel;

@end

@interface MJKClueDetailViewController : DBBaseViewController
@property(nonatomic,assign)id<MJKClueDetailViewControllerDelegate>delegate;


@property (nonatomic, strong) MJKClueListMainSecondModel *clueListMainSecondModel;
@property (nonatomic, strong) UIViewController *VC;
//下发时间
@property (nonatomic, strong) NSString *total;
@property (nonatomic, copy) void(^backViewBlock)(NSString *str);
@end
