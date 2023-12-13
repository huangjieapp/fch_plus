//
//  MJKAddressTableViewCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAddressTableViewCell.h"

@interface MJKAddressTableViewCell ()<UITextViewDelegate>
@end

@implementation MJKAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    self.textField.enabled = NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.alpha = 1.f;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
	if (self.changeTextBlock) {
		self.changeTextBlock(textView.text);
	}
}


- (IBAction)chooseArea:(UIButton *)sender {
    if (self.selectAreaBlock) {
        self.selectAreaBlock();
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length <= 0) {
        self.textView.alpha = 0.1f;
    }
	

}

- (CGFloat)cellHeight {
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
    CGSize size = [self.textView.text boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (size.height > 44) {
        return size.height + 10;
    } else {
        return 44;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAddressTableViewCell";
    MJKAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
