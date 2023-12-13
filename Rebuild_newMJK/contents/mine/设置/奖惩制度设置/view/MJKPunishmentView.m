//
//  MJKRewardsView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKPunishmentView.h"

#import "MJKCustomReturnSubModel.h"

@interface MJKPunishmentView ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
/** */
@property (nonatomic, strong) NSString *moneyStr;

@end

@implementation MJKPunishmentView

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

- (void)setModel:(MJKCustomReturnSubModel *)model {
    _model = model;
    if (![model.B_FIXEDNUMBER isEqualToString:@"0.00"]) {
        self.moneyTF.text = model.B_FIXEDNUMBER;
    }
    
}

- (IBAction)changeValue:(UITextField *)sender {
    self.moneyStr = sender.text;
    if (self.changeValueBlock) {
        self.changeValueBlock(sender.text);
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
    if (self.moneyStr.length <= 0) {
        [JRToast showWithText:@"请输入金额"];
        return;
    }
    if (self.sureButtonActionBlock) {
        self.sureButtonActionBlock();
    }
    [self removeFromSuperview];
}

@end
