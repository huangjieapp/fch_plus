//
//  MJKRewardsView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKRewardsView.h"

#import "MJKCustomReturnSubModel.h"

@interface MJKRewardsView ()
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *fixedButton;
@property (weak, nonatomic) IBOutlet UIButton *randomButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *mkLabel;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *numStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) NSString *randomFirstStr;
@property (nonatomic, strong) NSString *randomSecondStr;
@property (weak, nonatomic) IBOutlet UIView *randomView;
@property (weak, nonatomic) IBOutlet UITextField *randomFirstTF;
@property (weak, nonatomic) IBOutlet UITextField *randomSecondTF;

@end

@implementation MJKRewardsView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSInteger m = 8;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m, 40)];
    self.moneyTF.leftView = paddingView;
    self.moneyTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [super setFrame:frame];
}

- (void)setHiddenStr:(NSString *)hiddenStr {
    _hiddenStr = hiddenStr;
    self.mkLabel.hidden = self.gLabel.hidden = self.numberTF.hidden = YES;
}

- (void)setModel:(MJKCustomReturnSubModel *)model {
    _model = model;
    self.numberTF.text = model.I_INDEXNUMBER;
    self.numStr = model.I_INDEXNUMBER;
    if ([model.C_XFTYPE_DD_ID isEqualToString:@"A47500_C_XFTYPE_0001"]) {
        self.randomView.hidden = NO;
        self.moneyTF.hidden = YES;
        if (![model.B_MINNUMBER isEqualToString:@"0.00"]) {
            self.randomFirstTF.text = model.B_MINNUMBER;
        }
        if (![model.B_MAXNUMBER isEqualToString:@"0.00"]) {
            self.randomSecondTF.text = model.B_MAXNUMBER;
        }
        
        self.randomFirstStr = model.B_MINNUMBER;
        self.randomSecondStr = model.B_MAXNUMBER;
        [self.fixedButton setImage:@"icon_1_normal"];
        [self.randomButton setImage:@"icon_1_highlight"];
    } else {
        self.randomView.hidden = YES;
        self.moneyTF.hidden = NO;
        if (![model.B_FIXEDNUMBER isEqualToString:@"0.00"]) {
            self.moneyTF.text = model.B_FIXEDNUMBER;
        }
        
        self.moneyStr = model.B_FIXEDNUMBER;
        [self.fixedButton setImage:@"icon_1_highlight"];
        [self.randomButton setImage:@"icon_1_normal"];
    }
    
}

- (IBAction)changeValue:(UITextField *)sender {
    if (sender == self.numberTF) {
        self.numStr = sender.text;
        if (self.changeValueBlock) {
            self.changeValueBlock(@"number", sender.text);
        }
    } else if (sender == self.moneyTF) {
        self.moneyStr = sender.text;
        if (self.changeValueBlock) {
            self.changeValueBlock(@"money", sender.text);
        }
    } else if (sender == self.randomFirstTF) {
        self.randomFirstStr = sender.text;
        if (self.changeValueBlock) {
            self.changeValueBlock(@"randomFirst", sender.text);
        }
    } else {
        self.randomSecondStr = sender.text;
        if (self.changeValueBlock) {
            self.changeValueBlock(@"randomSecond", sender.text);
        }
    }
}

- (IBAction)buttonClickAction:(UIButton *)sender {
    if (sender == self.fixedButton) {
        [self.fixedButton setImage:@"icon_1_highlight"];
        [self.randomButton setImage:@"icon_1_normal"];
        self.moneyTF.hidden = NO;
        self.randomView.hidden = YES;
    } else {
        [self.fixedButton setImage:@"icon_1_normal"];
        [self.randomButton setImage:@"icon_1_highlight"];
        self.moneyTF.hidden = YES;
        self.randomView.hidden = NO;
    }
    if (self.fixedOrRandomBlock) {
        self.fixedOrRandomBlock(sender == self.fixedButton ? @"A47500_C_XFTYPE_0000" : @"A47500_C_XFTYPE_0001");
    }
}
- (void)closeView{
    if (self.cancelViewBlock) {
        self.cancelViewBlock();
    }
    [self removeFromSuperview];
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self closeView];
}
- (IBAction)sureButtonAction:(UIButton *)sender {
    if (![self.hiddenStr isEqualToString:@"隐藏"]) {
        if (self.numStr.length <= 0) {
            [JRToast showWithText:@"请输入门槛"];
            return;
        }
    }
    if (self.moneyTF.hidden == NO) {
        if (self.moneyStr.length <= 0) {
            [JRToast showWithText:@"请输入金额"];
            return;
        }
    } else {
        if (self.randomFirstStr.length <= 0) {
            [JRToast showWithText:@"请输入金额"];
            return;
        }
        if (self.randomSecondStr.length <= 0) {
            [JRToast showWithText:@"请输入金额"];
            return;
        }
    }
    
    if (self.sureButtonActionBlock) {
        self.sureButtonActionBlock();
    }
    [self removeFromSuperview];
}

@end
