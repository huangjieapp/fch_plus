//
//  SignatureView.m
//  PanGesture
//
//  Created by 张昭 on 16/3/3.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import "SignatureView.h"
#import <QuartzCore/QuartzCore.h>

@interface SignatureView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation SignatureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.path = [[UIBezierPath alloc] init];
        
        CAShapeLayer *shareLayer = (CAShapeLayer *)self.layer;
        shareLayer.strokeColor = [UIColor blackColor].CGColor;
        shareLayer.fillColor = [UIColor clearColor].CGColor;
        shareLayer.lineCap = kCALineCapRound;
        shareLayer.lineJoin = kCALineJoinRound;
        shareLayer.lineWidth = 5;
        
    }
    return self;
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.path addLineToPoint:point];
    
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
    
}



- (UIImage *)saveScreen {
    
    // 截屏
    UIView *screenView = self;
    UIGraphicsBeginImageContext(screenView.bounds.size);
    [screenView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
