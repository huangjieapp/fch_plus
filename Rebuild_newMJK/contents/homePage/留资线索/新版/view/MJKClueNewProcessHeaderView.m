//
//  MJKClueNewProcessHeaderView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKClueNewProcessHeaderView.h"

#import "MJKClueDetailModel.h"

@interface MJKClueNewProcessHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *firstButtonGoto;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLeftLayout;
@property (weak, nonatomic) IBOutlet UIButton *secondButtonGoto;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fistGotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondGotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneAndAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *personButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation MJKClueNewProcessHeaderView

- (void)setModel:(MJKClueDetailModel *)model {
    _model = model;
    self.firstNameLabel.text = model.C_NAME;
    if (model.C_A41500_C_ID.length <= 0) {
        self.fistGotoImageView.hidden = YES;
        self.secondLeftLayout.constant = -15;
    }
    if (model.C_A47700_C_NAME.length > 0) {
        self.secondNameLabel.text = [NSString stringWithFormat:@"/%@",model.C_A47700_C_NAME] ;
        self.secondNameLabel.hidden = NO;
    } else {
        self.secondNameLabel.hidden = YES;
    }
    if (model.C_A47700_C_ID.length <= 0) {
        self.secondGotoImageView.hidden = YES;
    } else {
        self.secondGotoImageView.hidden = NO;
    }
    if (model.C_A48200_C_NAME.length > 0) {
        self.phoneAndAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.C_PHONE,model.C_A48200_C_NAME, model.C_ADDRESS];
    } else {
        self.phoneAndAddressLabel.text = [NSString stringWithFormat:@"%@ %@",model.C_PHONE, model.C_ADDRESS];
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.D_LEAD_TIME, model.C_CLUESOURCE_DD_NAME,model.C_A41200_C_NAME,model.intentionDesc];
        self.saleNameLabel.text = model.C_OWNER_ROLENAME;
    
    
    self.statusLabel.text = model.C_STATUS_DD_NAME;
    
    self.remarkTextView.text = model.X_REMARK;
    self.remarkTextView.editable = NO;
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(sender.tag);
    }
}
- (IBAction)secondGotoAction:(UIButton *)sender {
    if (self.secondGotoActionBlock) {
        self.secondGotoActionBlock();
    }
}

- (IBAction)firstGotoAction:(UIButton *)sender {
    if (self.firstGotoActionBlock) {
        self.firstGotoActionBlock();
    }
}


- (void)setFrame:(CGRect)frame {
    frame.origin.y = SafeAreaTopHeight;
    frame.size.width = KScreenWidth;
    [super setFrame:frame];
}

@end
