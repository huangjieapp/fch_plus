//
//  DBAssignBottomChooseView.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "DBAssignBottomChooseView.h"

@interface DBAssignBottomChooseView()
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseAllButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation DBAssignBottomChooseView


+(instancetype)AssignBottomChooseViewAndcancel:(cancelBlock)cancelB allChoose:(allChooseBlock)allChooseB sure:(sureBlock)sureB{
    DBAssignBottomChooseView*selfView=[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    selfView.cancelB=cancelB;
    selfView.allChooseB=allChooseB;
    selfView.sureB=sureB;
    
    
    return selfView;
}



- (IBAction)clickCancel:(id)sender {
    if (self.cancelB) {
        self.cancelB();
    }
    
}

- (IBAction)clickChooseAll:(id)sender {
    if (self.allChooseB) {
        self.allChooseB();
    }
}
- (IBAction)clickSure:(id)sender {
    if (self.sureB) {
        self.sureB();
    }
}

@end
