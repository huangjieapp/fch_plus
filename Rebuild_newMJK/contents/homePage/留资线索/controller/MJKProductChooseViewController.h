//
//  MJKProductChooseViewController.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKProductChooseViewController : DBBaseViewController
/** 选择产品数组*/
@property (nonatomic, strong) NSMutableArray *productArray;
/** 选择的产品返回*/
@property (nonatomic, copy) void(^chooseProductBlock)(NSArray *productArray);
@end

NS_ASSUME_NONNULL_END
