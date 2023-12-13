//
//  MJKApprolViewRemark.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/11/9.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKApprolViewRemark.h"

@implementation MJKApprolViewRemark

- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [super setFrame:frame];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)trueButtonAction:(id)sender {
    if (self.remarkTF.text.length <=0) {
        [JRToast showWithText:@"请输入备注"];
        return;
    }
    if (self.changeTextBlock) {
        self.changeTextBlock(self.remarkTF.text);
    }
}
- (IBAction)tfChangeText:(UITextField *)sender {
    
}

@end
