//
//  MJKBusinessCardSetFunctionCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/27.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBusinessCardSetFunctionCell.h"

@interface MJKBusinessCardSetFunctionCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *switchCollection;

@end

@implementation MJKBusinessCardSetFunctionCell

- (void)switchButtonAction:(UISwitch *)sender {
    if (self.openSwitchAction) {
        self.openSwitchAction(sender);
    }
//    NSLog(@"");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *arr = [NSArray arrayWithObjects:[[NewUserSession instance].I_MP_SQ intValue] != 0 ? [NewUserSession instance].I_MP_SQ : @"0",[[NewUserSession instance].I_RMCP_SQ intValue] != 0 ? [NewUserSession instance].I_RMCP_SQ : @"0",[[NewUserSession instance].I_JXKL_SQ intValue] != 0 ? [NewUserSession instance].I_JXKL_SQ : @"0",[[NewUserSession instance].I_ZXHD_SQ intValue] != 0 ? [NewUserSession instance].I_ZXHD_SQ : @"0", nil];
    
    if ([[NewUserSession instance].I_MP_SQ intValue] == 0) {
        self.mpLabel.hidden = YES;
    } else {
        self.mpLabel.hidden = NO;
        if ([[NewUserSession instance].I_MP_SQ intValue] == 1) {
            self.mpLabel.text = @"访客浏览无需授权";
        } else if ([[NewUserSession instance].I_MP_SQ intValue] == 2) {
            self.mpLabel.text = @"访客浏览提示授权";
        } else {
            self.mpLabel.text = @"访客浏览强制授权";
        }
    }
    if ([[NewUserSession instance].I_RMCP_SQ intValue] == 0) {
        self.scLabel.hidden = YES;
    } else {
        self.scLabel.hidden = NO;
        if ([[NewUserSession instance].I_RMCP_SQ intValue] == 1) {
            self.scLabel.text = @"访客浏览无需授权";
        } else if ([[NewUserSession instance].I_RMCP_SQ intValue] == 2) {
            self.scLabel.text = @"访客浏览提示授权";
        } else {
            self.scLabel.text = @"访客浏览强制授权";
        }
    }
    if ([[NewUserSession instance].I_JXKL_SQ intValue] == 0) {
        self.alLabel.hidden = YES;
    } else {
        self.alLabel.hidden = NO;
        if ([[NewUserSession instance].I_JXKL_SQ intValue] == 1) {
            self.alLabel.text = @"访客浏览无需授权";
        } else if ([[NewUserSession instance].I_JXKL_SQ intValue] == 2) {
            self.alLabel.text = @"访客浏览提示授权";
        } else {
            self.alLabel.text = @"访客浏览强制授权";
        }
    }
    if ([[NewUserSession instance].I_ZXHD_SQ intValue] == 0) {
        self.hdLabel.hidden = YES;
    } else {
        self.hdLabel.hidden = NO;
        if ([[NewUserSession instance].I_ZXHD_SQ intValue] == 1) {
            self.hdLabel.text = @"访客浏览无需授权";
        } else if ([[NewUserSession instance].I_ZXHD_SQ intValue] == 2) {
            self.hdLabel.text = @"访客浏览提示授权";
        } else {
            self.hdLabel.text = @"访客浏览强制授权";
        }
    }
    
    for (int i = 0; i < self.switchCollection.count; i++) {
        UISwitch *switchButton = self.switchCollection[i];
        switchButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
        switchButton.on = [arr[i] boolValue];
        [switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventValueChanged];
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKBusinessCardSetFunctionCell";
    MJKBusinessCardSetFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
