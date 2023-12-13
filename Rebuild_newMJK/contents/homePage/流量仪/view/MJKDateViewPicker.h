//
//  MJKDateViewPicker.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/17.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^STARTBLOCK)();
typedef void(^ENDBLOCK)();
typedef void(^SUREBLOCK)(NSString * start,NSString *end);

@interface MJKDateViewPicker : UIView
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *canelBtn;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (nonatomic,strong) UIButton * pickerBtn;   //全屏的 选择时间器
@property (nonatomic, copy) STARTBLOCK startB;

@property (nonatomic, copy) ENDBLOCK endB;

@property (nonatomic, copy) SUREBLOCK sureB;

@property (nonatomic, copy) NSString *startStr;

@property (nonatomic, copy) NSString *endStr;
- (instancetype)initWithFrame:(CGRect)frame withStart:(STARTBLOCK)start withEnd:(ENDBLOCK)end withSure:(SUREBLOCK)sure;
//点击取消  按钮
@property(nonatomic,copy)void(^clickCancelBlock)();
@end
