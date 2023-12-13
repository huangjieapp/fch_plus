//
//  MJKPKShowView.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MJKPKShowView : UIView
- (void)createViewWithDataArray:(NSMutableArray *)dataArray;
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *jxChooseType;
@property (nonatomic, copy) void(^backDateBlock)(NSString *dateType);
/** 选中的人*/
@property (nonatomic, copy) void(^selectSaleBlock)(NSString *name);
/** 点击头像*/
@property (nonatomic, copy) void(^clickHeadImageBlock)(NSInteger index);
- (instancetype)initWithFrame:(CGRect)frame andDateType:(NSString *)dateType;
@end
