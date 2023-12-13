//
//  MJKHomePageCompleteCollectionCell.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKHomePageCompleteCollectionCell.h"

@implementation MJKHomePageCompleteCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setJxModel:(MJKHomePageJXModel *)jxModel {
	_jxModel = jxModel;
	self.titleLabel.text = jxModel.typeName;
//	if ([jxModel.NAME isEqualToString:@"预估金额"] || [jxModel.NAME isEqualToString:@"回款金额"]) {
//		if ([jxModel.MIDCOUNT isEqualToString:@"0"]) {
//			self.completeLabel.text = jxModel.MIDCOUNT;
//		} else {
//			NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",jxModel.MIDCOUNT]];
//			[str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f]} range:NSMakeRange(jxModel.MIDCOUNT.length, 1)];
//			self.completeLabel.attributedText = str;
//		}
//
//		if ([jxModel.MB isEqualToString:@"0"]) {
//			self.targetLabel.text = jxModel.MB;
//		} else {
//			NSMutableAttributedString *mbStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@万",jxModel.MB]];
//			[mbStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8.f]} range:NSMakeRange(jxModel.MB.length, 1)];
//			self.targetLabel.attributedText = mbStr;
//		}
//
//	} else {
		self.completeLabel.text = jxModel.WC;
		self.targetLabel.text = jxModel.MB;
//	}
}

@end
