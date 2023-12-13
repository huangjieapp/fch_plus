//
//  CGCAlertDateView.h
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DATESELECT)();


typedef void(^SUREBLOCK)(NSString * title,NSString *dateStr);

@interface CGCAlertDateView : UIView
/** 视图*/
@property (nonatomic, strong) NSString *VCName;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *bgBtn;

@property (weak, nonatomic) IBOutlet UITextField *textfield;   //placeholder   请选择战败类型

@property (weak, nonatomic) IBOutlet UIButton *selbtn;

@property (weak, nonatomic) IBOutlet UIButton *canelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UITextField *remarkText;   //placeholder  到店备注

@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHight;
/** <#注释#>*/
@property (nonatomic, strong) NSString *noticeStr;

@property (nonatomic,strong) UIButton * pickerBtn;

@property (nonatomic, copy) void(^cancelActionBlock)(void);

//130的时候是  没有备注的  180有备注     当chooseArray的时候不是时间选择了 是array选择
- (instancetype)initWithFrame:(CGRect)frame withSelClick:(DATESELECT)dateSel withSureClick:(SUREBLOCK)sureClick withHight:(CGFloat)hight withText:(NSString *)text withDatas:(NSArray*)chooseArray;

@end
