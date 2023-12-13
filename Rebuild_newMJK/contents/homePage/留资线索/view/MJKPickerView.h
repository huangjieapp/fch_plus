//
//  MJKPickerView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKPickerView : UIView
@property (nonatomic, copy) void(^selectBlock)(NSString *name, NSString *Volune,NSString*marketC_id);
@property (nonatomic, strong) NSArray <MJKDataDicModel *>*arr;
@property (nonatomic, assign) NSInteger indexRow;
//- (void)createPickerView:(NSArray *)arr;
@end
