//
//  MJKGoodPaperInputTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKGoodPaperInputTableViewCell.h"

@interface MJKGoodPaperInputTableViewCell ()<UITextViewDelegate>
@end

@implementation MJKGoodPaperInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTextView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewChangeBlock) {
        self.textViewChangeBlock(textView.text);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKGoodPaperInputTableViewCell";
    MJKGoodPaperInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
