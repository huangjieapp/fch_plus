//
//  CGCGoodsDetailView.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CONTINUEBLOCK)();

typedef void(^FINISHBLOCK)();

typedef void(^CANELBLOCK)();

typedef void(^DELROWBLOCK)(NSInteger index);

@interface CGCGoodsDetailView : UIView

@property (nonatomic,strong) NSMutableArray * dataArray;

@property(nonatomic,copy)CONTINUEBLOCK cont;

@property(nonatomic,copy)FINISHBLOCK finish;

@property(nonatomic,copy)DELROWBLOCK del;

@property(nonatomic,copy)CANELBLOCK canelB;
- (void)reloadTable;

@end
