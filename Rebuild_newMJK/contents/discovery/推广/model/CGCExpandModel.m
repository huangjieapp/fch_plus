//
//  CGCExpandModel.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCExpandModel.h"


@implementation CGCExpandModel
{
    CGFloat _cellHeight;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"sid" : @"id"
             };
}

- (CGFloat)cellHeight
{
    /** 精华-cell-间距 */
    CGFloat const XMGTopicCellMargin = 20;
    /** 精华-cell-文字内容的Y值 */
    CGFloat const XMGTopicCellTextY = 30;
    
    
    if (!_cellHeight) {
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake(WIDE - 2 * XMGTopicCellMargin, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        // cell的高度
        // 文字部分的高度
        _cellHeight = XMGTopicCellTextY + textH ;
        
        CGFloat titleH = [self.title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight += titleH;
        
       CGFloat addressH = [self.addressName boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _cellHeight += addressH;
        // 根据段子的类型来计算cell的高度
        if ([self.type integerValue] == 0) { // 图片
          
            NSInteger count=self.images.count;
            
            CGFloat w=(WIDE-120)/3;
         
            CGFloat h= XMGTopicCellMargin;
            
            if (count<=3&&count>0) {
                h=w+2*XMGTopicCellMargin;
            }else if (count>3&&count<=6){
                h=w*2+3*XMGTopicCellMargin;
            }else if (count>6&&count<=9){
                 h=w*3+4*XMGTopicCellMargin;
            }
            
            _pictureF=CGRectMake(0, XMGTopicCellTextY + textH +XMGTopicCellMargin, WIDE, h + textH);
            _cellHeight+=h+XMGTopicCellMargin;
            
            
        } else if ([self.type integerValue] == 1) { // 视频
            
            _videoF=CGRectMake(10,  XMGTopicCellTextY + textH +XMGTopicCellMargin, WIDE-2*XMGTopicCellMargin, WIDE - 120);
            
            
            _cellHeight+=WIDE;
        } else if ([self.type integerValue] == 3) { // 视频帖
            _videoF=CGRectMake(10,  XMGTopicCellTextY + textH +XMGTopicCellMargin, WIDE-2*XMGTopicCellMargin, WIDE-2*XMGTopicCellMargin);
            
            
            _cellHeight+=WIDE;
        }
        
      
        // 底部工具条的高度
//        _cellHeight += XMGTopicCellBottomBarH + XMGTopicCellMargin;
    }
    return _cellHeight;
}





@end
