//
//  MJKMRRemarkCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKMRRemarkCell.h"

@interface MJKMRRemarkCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;
@end

@implementation MJKMRRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
//	//添加长按手势
//	UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
//	self.voiceImageView.userInteractionEnabled = YES;
//	[self.voiceImageView addGestureRecognizer:longPressGesture];
}

//- (void)cellLongPress:(UILongPressGestureRecognizer *)sender {
//	if (sender.state == UIGestureRecognizerStateBegan) {
//		if (self.beginLongBlock) {
//			self.beginLongBlock();
//		}
//	} else if (sender.state == UIGestureRecognizerStateEnded) {
//		if (self.endLongBlock) {
//			self.endLongBlock();
//		}
//	}
//}

-(void)textViewDidChange:(UITextView *)textView {
	if (self.changeBlock) {
		self.changeBlock(textView.text);
	}
}
- (IBAction)voiceButtonAction:(UIButton *)sender {
	if (self.beginLongBlock) {
		self.beginLongBlock();
	}

}

-(void)textViewDidBeginEditing:(UITextView *)textView {
	if (self.beginBlock) {
		self.beginBlock();
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if (self.endBlock) {
		self.endBlock();
	}
}


#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKMRRemarkCell";
	MJKMRRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}

@end
