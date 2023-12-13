//
//  SendMessageTableViewCell.m
//  Mcr_2
//
//  Created by bipi on 2017/3/31.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "SendMessageTableViewCell.h"

@implementation SendMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        
        
        if ([NSStringFromClass(subView.class) hasSuffix:@"SeparatorView"]) {
            subView.hidden = NO;
        }
        
        
        
        
        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            
            if (subView.subviews.count>=1) {
                UIView *ConfirmationView = subView.subviews[0];
ConfirmationView.backgroundColor=[UIColor colorWithRed:255/255.0 green:195/255.0 blue:0/255.0 alpha:1];
            }
            
            if (subView.subviews.count>=2) {
                UIView *ConfirmationView2 = subView.subviews[1];
                ConfirmationView2.backgroundColor=[UIColor lightGrayColor];            }

            
            
            
            
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
