//
//  ZhanbaiChooseTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/19.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ZhanbaiChooseTableViewCell.h"
@interface ZhanbaiChooseTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end



@implementation ZhanbaiChooseTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    _falseButton.adjustsImageWhenHighlighted=NO;
    _tureButton.adjustsImageWhenHighlighted=NO;
    
    [_falseButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
      [_falseButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateSelected];
    
    [_tureButton setBackgroundImage:[UIImage imageNamed:@"未打钩"] forState:UIControlStateNormal];
    [_tureButton setBackgroundImage:[UIImage imageNamed:@"打钩"] forState:UIControlStateSelected];

    [self clickFalseButton:_falseButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}


- (IBAction)clickTureButton:(UIButton*)sender {
    if (sender.selected) {
        
        return;
    }
    sender.selected=!sender.selected;
    self.falseButton.selected=!sender.selected;
    
    if (self.clickSelectedButtonBlock) {
        self.clickSelectedButtonBlock(1);
    }
    
    
}

- (IBAction)clickFalseButton:(UIButton*)sender {
    if (sender.selected) {
        
        return;
    }
    
    sender.selected=!sender.selected;
    self.tureButton.selected=!sender.selected;
    
    
    if (self.clickSelectedButtonBlock) {
        self.clickSelectedButtonBlock(0);
    }
    
}



#pragma mark  --set
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.titleL.text=_titleStr;
    self.titleL.textColor=[UIColor colorWithHexString:@"#3C3C3C"];
    
}


-(void)setNumber:(NSInteger)number{
    _number=number;
    if (number==0) {
        [self clickFalseButton:self.falseButton];
        
    }else{
        [self clickFalseButton:self.tureButton];
    }
    
}


@end
