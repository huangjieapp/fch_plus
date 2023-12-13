//
//  CGCCustomDateView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^STARTBLOCK)();
typedef void(^ENDBLOCK)();
typedef void(^HOURLOCK)();
typedef void(^SUREBLOCK)(NSString * start,NSString *end, NSString *hour);

@interface MJKNewSelectHourView : UIView
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *canelBtn;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *hourBtn;

@property (weak, nonatomic) IBOutlet UILabel *startTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeTitleLabel;
@property(nonatomic,assign)BOOL canFirstOneSave;  //第一个就能提交 不用两个都要提交


@property (nonatomic,strong) UIButton * pickerBtn;   //全屏的 选择时间器
@property (nonatomic, copy) STARTBLOCK startB;

@property (nonatomic, copy) ENDBLOCK endB;
@property (nonatomic, copy) HOURLOCK hourB;

@property (nonatomic, copy) SUREBLOCK sureB;

@property (nonatomic, copy) NSString *startStr;

@property (nonatomic, copy) NSString *endStr;
@property (nonatomic, copy) NSString *hourStr;
- (instancetype)initWithFrame:(CGRect)frame withStart:(STARTBLOCK)start withEnd:(ENDBLOCK)end withHour:(HOURLOCK)hour withSure:(SUREBLOCK)sure;
//点击取消  按钮
@property(nonatomic,copy)void(^clickCancelBlock)();



@end
