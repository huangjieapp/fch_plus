//
//  CGCRecordPlaceholderView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCRecordPlaceholderView.h"

@interface CGCRecordPlaceholderView()
{
    CGRect _rect;
}

@end
@implementation CGCRecordPlaceholderView



- (instancetype)initWithFrame:(CGRect)frame{


    if (self=[super initWithFrame:frame]) {
        self=[[[NSBundle mainBundle] loadNibNamed:@"CGCRecordPlaceholderView" owner:self options:nil] lastObject];
        _rect=frame;
    }
    return self;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [self.window addSubview:self];
}
- (void)dismiss{
    [self removeFromSuperview];
}

-(void)layoutSubviews{
    CGFloat navHeight = [[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64;
    self.width=KScreenWidth;
    self.height=_rect.size.height;
    self.y=navHeight;
}
@end
