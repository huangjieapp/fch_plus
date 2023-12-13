//
//  ProgressView.m
//  MZSJ
//
//  Created by 吴伯程 on 16/6/13.
//  Copyright © 2016年 李小龙. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@end

@implementation ProgressView

- (void)dealloc {
    //MYLog(@"%s", __func__);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _drawColor = DBColor(71, 121, 237);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(16, 16) radius:rect.size.width * 0.4 startAngle:M_PI_2*3 endAngle:self.progress*M_PI*2+M_PI_2*3 clockwise:YES];
    [_drawColor setStroke];
    roundPath.lineWidth = 3;
    [roundPath stroke];
    
    if (!_hiddenCenter) {
        UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:CGRectMake(12, 12, 8, 8)];
        [_drawColor setFill];
        [rectanglePath fill];
    }
}

@end
