//
//  MJKMarketPickerView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PickerViewStyle) {
	PickerViewDateStyle,//时间
	PickerViewDataStyle
};

@interface MJKMarketPickerView : UIView
@property (nonatomic) PickerViewStyle style;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray <MJKDataDicModel *>*modelArray;
@property (nonatomic, copy) void(^selectTextBlock)(NSString *name, NSString *code);
- (void)popPickerView;

@end
