//
//  MJKClueMemoInDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/30.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueMemoInDetailTableViewCell.h"

@interface MJKClueMemoInDetailTableViewCell ()<UITextViewDelegate>

@end

@implementation MJKClueMemoInDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.memoTextView.layer.borderColor = DBColor(166, 166, 166).CGColor;
	self.memoTextView.layer.borderWidth = 1.f;
	self.memoTextView.layer.masksToBounds = YES;
	self.memoTextView.layer.cornerRadius = 5.0f;
	self.memoTextView.textColor = DBColor(131, 131, 131);
//	self.memoTextView.editable = NO;
	self.memoTextView.layoutManager.allowsNonContiguousLayout = NO;
	self.memoTextView.delegate = self;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];

    
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    
}



- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textViewKeyBoardShow];
    
    if (self.KeyBoardBlock) {
        self.KeyBoardBlock(textView);
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollLastCell)]) {
        [self.delegate scrollLastCell];
    }
    
    
}

- (void)textViewDidChange:(UITextView *)textView {
	if (self.backTextViewBlock) {
		self.backTextViewBlock(textView.text);
	}
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"MJKClueMemoInDetailTableViewCell";
	MJKClueMemoInDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
		
	}
	return cell;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark  --funcation
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)textViewKeyBoardShow{
    //    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    UIView*superView=[DBTools getSuperViewWithsubView:self].view;
    CGRect rect=[self.memoTextView convertRect:_memoTextView.bounds toView:superView];
    
    CGFloat aa = KScreenHeight - (rect.origin.y + rect.size.height + 216 +50+30+50+50);
    //    +self.view.frame.origin.y
    CGFloat rects=aa;
    
    NSLog(@"aa%f",rects);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = superView.frame;
            //frame.origin.y+
            frame.origin.y = rects;
            
            superView.frame = frame;
            
        }];
        
    }

    
}


-(void)keyBoardWillHidden:(NSNotification*)notif{
    UIView*superView=[DBTools getSuperViewWithsubView:self].view;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = superView.frame;
        
        frame.origin.y = 0.0;
        
        superView.frame = frame;
        
    }];
    
}



@end
