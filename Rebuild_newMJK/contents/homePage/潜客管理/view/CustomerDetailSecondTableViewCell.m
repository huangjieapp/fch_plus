//
//  CustomerDetailSecondTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailSecondTableViewCell.h"
#import "VoiceRecordModel.h"

@interface CustomerDetailSecondTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation CustomerDetailSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.remarkLabel.textColor=DBColor(60, 60, 60);
    self.remarkLabel.text=@"来电号码:15487585898\n渠道细分:地推\n来电备注:";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setVoiceModel:(VoiceRecordModel *)voiceModel {
    _voiceModel = voiceModel;
    
    
    self.timeLabel.text=voiceModel.D_CALL_DATE_START;
    
    
    self.TypeLabel.text=voiceModel.I_CALL_TYPE.integerValue == 2 ? @"外呼": @"";
    if ([voiceModel.I_CALL_TIME isEqualToString:@"0"]) {
        self.remarkLabel.text = @"未接通";
    } else {
        if (voiceModel.C_URL.length > 0) {
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:voiceModel.isSelected == YES ? @"播放中" : @"播放"];
            attch.bounds = CGRectMake(10, -3, 20, 20);
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"结束时间:%@\n通话时长:%@",voiceModel.D_CALL_DATE_END.length > 10 ? [voiceModel.D_CALL_DATE_END substringFromIndex:11] : @"", [DBTools getMMSSFromSS:voiceModel.I_CALL_TIME] ]];
            NSAttributedString *b_string = [NSAttributedString attributedStringWithAttachment:attch];
            [result insertAttributedString:b_string atIndex:result.length];
            self.remarkLabel.attributedText = result;
        } else {
            self.remarkLabel.text = [NSString stringWithFormat:@"结束时间:%@\n通话时长:%@",voiceModel.D_CALL_DATE_END.length > 10 ? [voiceModel.D_CALL_DATE_END substringFromIndex:11] : @"", [DBTools getMMSSFromSS:voiceModel.I_CALL_TIME] ];
        }
    }
}


#pragma mark  --click
- (IBAction)clickScaleButton:(id)sender {
    if (self.clickScaleBlock) {
        self.clickScaleBlock(self.MainModel);
    }
}




#pragma mark  --set
-(void)setMainModel:(CustomerDetailPathDetailModel *)MainModel{
    _MainModel=MainModel;
    
    self.timeLabel.text=MainModel.D_SHOW_TIME;
    
    NSString *str1;
    NSString *str2;
    if (MainModel.C_TYPE.length >= 4) {
        str1 = [MainModel.C_TYPE substringToIndex:2];
        str2 = [MainModel.C_TYPE substringFromIndex:2];
    }
    
    self.TypeLabel.text=MainModel.C_TYPE.length >= 4 ? [NSString stringWithFormat:@"%@\n%@",str1,str2] : MainModel.C_TYPE;
    self.remarkLabel.text=MainModel.X_REMARK;
    
}

- (void)updataHistoryCell:(MJKHistorySubModel *)model {
	self.timeLabel.text = model.D_CREATE_TIME;
	self.TypeLabel.text = model.C_OWNER_ROLENAME;
	self.remarkLabel.text = model.X_REMARK;
}




@end
