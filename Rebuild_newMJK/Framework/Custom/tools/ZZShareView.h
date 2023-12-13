//
//  ZZShareView.h
//  uliaobao
//
//  Created by wisdom on 16/2/23.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZShareView;

@protocol ZZShareDelegate <NSObject>

- (void)selectBtn:(ZZShareView *)shareView withButtonTitle:(NSString*)buttonTitle;

@end
@interface ZZShareView : UIView
@property (nonatomic,weak) id<ZZShareDelegate>delegate;

- (instancetype)initWithdelegate:(id<ZZShareDelegate>)delegate;
- (instancetype)initWithdelegate:(id<ZZShareDelegate>)delegate withArr:(NSArray *)arr;
@property (nonatomic,strong)NSMutableArray *keyWordArr;

@end
