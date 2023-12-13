//
//  ViewController.m
//  BezierPath
//
//  Created by 黄杰 on 2019/3/11.
//  Copyright © 2019 黄杰. All rights reserved.
//

#import "MJKMessageMapViewController.h"

#import "MJKMessageMapEditViewController.h"

@interface MJKMessageMapViewController ()
@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (strong, nonatomic) UIView *view3;
@property (strong, nonatomic) UIView *view4;
@property (strong, nonatomic) UIView *view5;
@property (strong, nonatomic) UIView *view6;
@property (strong, nonatomic) UIView *view7;
@property (strong, nonatomic) UIView *view8;

@end

@implementation MJKMessageMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleName;
    [self configNavi];
    [self configUI];
    
}

- (void)configNavi {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [button setTitleNormal:@"问答题库"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)configUI {
    CGFloat width = 83;
    CGFloat height = 48;
    self.view4 = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth - width) / 2 - 10, (KScreenHeight - height) / 2, width, height)];
    self.view4.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view4];
    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMinY(self.view4.frame), width, height)];
    self.view1.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view1];
    
    self.view3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.view4.frame), CGRectGetMinY(self.view4.frame) - 30 - height, width, height)];
    self.view3.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view3];
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.view4.frame), CGRectGetMinY(self.view3.frame) - 30 - height, width, height)];
    self.view2.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view2];
    
    self.view5 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.view4.frame), CGRectGetMaxY(self.view4.frame) + 30 , width, height)];
    self.view5.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view5];
    
    self.view6 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.view4.frame), CGRectGetMaxY(self.view5.frame) + 30, width, height)];
    self.view6.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view6];
    
    self.view7 = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth - width - 30, CGRectGetMinY(self.view3.frame), width, height)];
    self.view7.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view7];
    
    self.view8 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.view7.frame), CGRectGetMinY(self.view5.frame), width, height)];
    self.view8.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.view8];
    
    //所有的view都需要lable和textview
    NSMutableArray *viewArray = [NSMutableArray array];
    [viewArray addObject:_view1];
    [viewArray addObject:_view2];
    [viewArray addObject:_view3];
    [viewArray addObject:_view4];
    [viewArray addObject:_view5];
    [viewArray addObject:_view6];
    [viewArray addObject:_view7];
    [viewArray addObject:_view8];
    
    for (int i = 0; i < viewArray.count; i++) {
        UIView *view = viewArray[i];
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 12)];
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.text = @"决绝";
        titleLabel.textColor = [UIColor blackColor];
        [view addSubview:titleLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(titleLabel.frame) , width - 4, height - 12)];
        titleLabel.textAlignment = label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.text = @"第六十九警方立即受到了房间就受到了房间里就是代理费死了老骥伏枥多久分类三等奖分类大家送福利啥的方式氮磷钾肥了三大纪律圣诞节福利送到家了睡觉了睡觉流口水的家分类快速的减肥了水电费水电费开始发牢骚的护肤老师电话发来说的话立刻回复说了了可视电话疯了似的恢复了精神的护肤老师凯迪拉克恢复速度发货速度来返回路上都看好了可视电话分类考试的";
        label.font = [UIFont systemFontOfSize:10.f];
        label.numberOfLines = 4;
        [view addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [button addTarget:self action:@selector(editButtonAction:)];
        [view addSubview:button];
    }
    //导线        
    [self configBezier];
}

- (void)configBezier {
    //前六个的导线
    NSMutableArray *viewArray = [NSMutableArray array];
    [viewArray addObject:_view2];
    [viewArray addObject:_view3];
    [viewArray addObject:_view4];
    [viewArray addObject:_view5];
    [viewArray addObject:_view6];
    
    
    CGPoint view1StartPoint = CGPointMake(CGRectGetMaxX(_view1.frame), CGRectGetMidY(_view1.frame));
    CGPoint view1Control1Point = CGPointMake(_view1.frame.origin.x + _view1.frame.size.width + 20, _view1.frame.origin.y + _view1.frame.size.height / 2);
    for (int i = 0; i < viewArray.count; i++) {
        UIView *view = viewArray[i];
        CAShapeLayer *shapeLayer = [self configBezierPathWithStartPoint:view1StartPoint andEndPoint:CGPointMake(view.frame.origin.x,  view.frame.origin.y + view.frame.size.height / 2) andControl1:view1Control1Point andControl2:CGPointMake(_view1.frame.origin.x + _view1.frame.size.width, view.frame.origin.y + view.frame.size.height / 2) andColor:@[[UIColor colorWithHex:@"#f8c63b"],[UIColor colorWithHex:@"#83164a"],[UIColor colorWithHex:@"#d91919"],[UIColor colorWithHex:@"#58ba85"],[UIColor colorWithHex:@"#1c279f"]][i]];
        [self.view.layer addSublayer:shapeLayer];
        
        CGPoint jiantouPoint = CGPointMake(view.frame.origin.x,  view.frame.origin.y + view.frame.size.height / 2);
        CAShapeLayer *jiantou = [self jiantou:jiantouPoint andFirstLine:CGPointMake(jiantouPoint.x - 4, jiantouPoint.y - 2) andSecondLine:CGPointMake(jiantouPoint.x - 4, jiantouPoint.y + 2) andColor:@[[UIColor colorWithHex:@"#f8c63b"],[UIColor colorWithHex:@"#83164a"],[UIColor colorWithHex:@"#d91919"],[UIColor colorWithHex:@"#58ba85"],[UIColor colorWithHex:@"#1c279f"]][i]];
        [self.view.layer addSublayer:jiantou];
    }
    
    //用户不说话-拒绝
    CAShapeLayer *shapeLayer3_4 = [self configBezierPathWithStartPoint:CGPointMake(_view3.frame.origin.x + _view3.frame.size.width, _view3.frame.origin.y + _view3.frame.size.height / 2) andEndPoint:CGPointMake(_view4.frame.origin.x + _view4.frame.size.width, _view4.frame.origin.y + _view4.frame.size.height / 2) andControl:CGPointMake(_view3.frame.origin.x + _view3.frame.size.width + 40, _view3.frame.origin.y + _view3.frame.size.height + 15) andColor:[UIColor colorWithHex:@"#83164a"]];
    [self.view.layer addSublayer:shapeLayer3_4];
    
    CGPoint shapeLayer3_4jiantouPoint = CGPointMake(_view4.frame.origin.x + _view4.frame.size.width, _view4.frame.origin.y + _view4.frame.size.height / 2);
    CAShapeLayer *shapeLayer3_4jiantou = [self jiantou:shapeLayer3_4jiantouPoint andFirstLine:CGPointMake(shapeLayer3_4jiantouPoint.x + 1, shapeLayer3_4jiantouPoint.y - 4) andSecondLine:CGPointMake(shapeLayer3_4jiantouPoint.x + 4, shapeLayer3_4jiantouPoint.y) andColor:[UIColor colorWithHex:@"#83164a"]];
    [self.view.layer addSublayer:shapeLayer3_4jiantou];
    
    //用户不说话-肯定
    CAShapeLayer *shapeLayer3_5 = [self configBezierPathWithStartPoint:CGPointMake(_view3.frame.origin.x + _view3.frame.size.width, _view3.frame.origin.y + _view3.frame.size.height / 2) andEndPoint:CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2) andControl:CGPointMake(_view3.frame.origin.x + _view3.frame.size.width + 70, _view3.frame.origin.y + _view3.frame.size.height + 15) andColor:[UIColor colorWithHex:@"#83164a"]];
    [self.view.layer addSublayer:shapeLayer3_5];
    
    CGPoint shapeLayer3_5jiantouPoint = CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2);
    CAShapeLayer *shapeLayer3_5jiantou = [self jiantou:shapeLayer3_5jiantouPoint andFirstLine:CGPointMake(shapeLayer3_5jiantouPoint.x + 1, shapeLayer3_5jiantouPoint.y - 4) andSecondLine:CGPointMake(shapeLayer3_5jiantouPoint.x + 4, shapeLayer3_5jiantouPoint.y) andColor:[UIColor colorWithHex:@"#83164a"]];
    [self.view.layer addSublayer:shapeLayer3_5jiantou];
    
    //用户不说话-兜底话术
    CAShapeLayer *shapeLayer3_7 = [self configBezierPathWithStartPoint:CGPointMake(_view3.frame.origin.x + _view3.frame.size.width, _view3.frame.origin.y + _view3.frame.size.height / 2) andEndPoint:CGPointMake(_view7.frame.origin.x + _view7.frame.size.width, _view7.frame.origin.y + _view7.frame.size.height / 2) andControl1:CGPointMake(_view7.frame.origin.x + _view3.frame.size.width / 2, _view7.frame.origin.y - 40) andControl2:CGPointMake(_view7.frame.origin.x + _view3.frame.size.width + 20, _view7.frame.origin.y - 40) andColor:[UIColor colorWithHex:@"#83164a"]];
    [self.view.layer addSublayer:shapeLayer3_7];
    
    CGPoint shapeLayer3_7jiantouPoint = CGPointMake(_view7.frame.origin.x + _view7.frame.size.width, _view7.frame.origin.y + _view7.frame.size.height / 2);
    CAShapeLayer *shapeLayer3_7jiantou = [self jiantou:shapeLayer3_7jiantouPoint andFirstLine:CGPointMake(shapeLayer3_7jiantouPoint.x, shapeLayer3_7jiantouPoint.y - 4) andSecondLine:CGPointMake(shapeLayer3_7jiantouPoint.x + 4, shapeLayer3_7jiantouPoint.y-2) andColor:[UIColor colorWithHex:@"#83164a"]];
    [self.view.layer addSublayer:shapeLayer3_7jiantou];
    
    //肯定-加微信
    CAShapeLayer *shapeLayer5_8 = [self configBezierPathWithStartPoint:CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2) andEndPoint:CGPointMake(_view8.frame.origin.x, _view8.frame.origin.y + _view8.frame.size.height / 2) andColor:[UIColor colorWithHex:@"#58ba85"]];
    [self.view.layer addSublayer:shapeLayer5_8];
    
    CGPoint shapeLayer5_8jiantouPoint = CGPointMake(_view8.frame.origin.x, _view8.frame.origin.y + _view8.frame.size.height / 2);
    CAShapeLayer *shapeLayer5_8jiantou = [self jiantou:shapeLayer5_8jiantouPoint andFirstLine:CGPointMake(shapeLayer5_8jiantouPoint.x - 4, shapeLayer5_8jiantouPoint.y - 2) andSecondLine:CGPointMake(shapeLayer5_8jiantouPoint.x - 4, shapeLayer5_8jiantouPoint.y + 2) andColor:[UIColor colorWithHex:@"#58ba85"]];
    [self.view.layer addSublayer:shapeLayer5_8jiantou];
    
    //无法识别-拒绝
    CAShapeLayer *shapeLayer6_4 = [self configBezierPathWithStartPoint:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width, _view6.frame.origin.y + _view6.frame.size.height / 2) andEndPoint:CGPointMake(_view4.frame.origin.x + _view4.frame.size.width, _view4.frame.origin.y + _view4.frame.size.height / 2) andControl:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width + 70, _view6.frame.origin.y - 15) andColor:[UIColor colorWithHex:@"#1c279f"]];
    [self.view.layer addSublayer:shapeLayer6_4];
    
    CGPoint shapeLayer6_4jiantouPoint = CGPointMake(_view4.frame.origin.x + _view4.frame.size.width, _view4.frame.origin.y + _view4.frame.size.height / 2);
    CAShapeLayer *shapeLayer6_4jiantou = [self jiantou:shapeLayer6_4jiantouPoint andFirstLine:CGPointMake(shapeLayer6_4jiantouPoint.x, shapeLayer6_4jiantouPoint.y + 4) andSecondLine:CGPointMake(shapeLayer6_4jiantouPoint.x + 4, shapeLayer6_4jiantouPoint.y+2) andColor:[UIColor colorWithHex:@"#1c279f"]];
    [self.view.layer addSublayer:shapeLayer6_4jiantou];
    
    //无法识别-肯定
    CAShapeLayer *shapeLayer6_5 = [self configBezierPathWithStartPoint:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width, _view6.frame.origin.y + _view6.frame.size.height / 2) andEndPoint:CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2) andControl:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width + 40, _view6.frame.origin.y - 15) andColor:[UIColor colorWithHex:@"#1c279f"]];
    [self.view.layer addSublayer:shapeLayer6_5];
    
    CGPoint shapeLayer6_5jiantouPoint = CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2);
    CAShapeLayer *shapeLayer6_5jiantou = [self jiantou:shapeLayer6_5jiantouPoint andFirstLine:CGPointMake(shapeLayer6_5jiantouPoint.x + 1, shapeLayer6_5jiantouPoint.y + 4) andSecondLine:CGPointMake(shapeLayer6_5jiantouPoint.x + 4, shapeLayer6_5jiantouPoint.y+2) andColor:[UIColor colorWithHex:@"#1c279f"]];
    [self.view.layer addSublayer:shapeLayer6_5jiantou];
    
    //无法识别-兜底话术
    CAShapeLayer *shapeLayer6_7 = [self configBezierPathWithStartPoint:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width, _view6.frame.origin.y + _view6.frame.size.height / 2) andEndPoint:CGPointMake(_view7.frame.origin.x + _view7.frame.size.width, _view7.frame.origin.y + _view7.frame.size.height / 2) andControl1:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width + _view6.frame.size.width + 15, _view6.frame.origin.y + _view6.frame.size.height / 2)  andControl2:CGPointMake(_view6.frame.origin.x + _view6.frame.size.width + _view6.frame.size.width  + _view6.frame.size.width + 15, _view6.frame.origin.y + _view6.frame.size.height / 2 + 30)  andColor:[UIColor colorWithHex:@"#1c279f"]];
    [self.view.layer addSublayer:shapeLayer6_7];
    
    CGPoint shapeLayer6_7jiantouPoint = CGPointMake(_view7.frame.origin.x + _view7.frame.size.width, _view7.frame.origin.y + _view7.frame.size.height / 2);
    CAShapeLayer *shapeLayer6_7jiantou = [self jiantou:shapeLayer6_7jiantouPoint andFirstLine:CGPointMake(shapeLayer6_7jiantouPoint.x, shapeLayer6_7jiantouPoint.y + 4) andSecondLine:CGPointMake(shapeLayer6_7jiantouPoint.x + 3, shapeLayer6_7jiantouPoint.y+3) andColor:[UIColor colorWithHex:@"#1c279f"]];
    [self.view.layer addSublayer:shapeLayer6_7jiantou];
    
    //兜底话术-拒绝
    CAShapeLayer *shapeLayer7_4 = [self configBezierPathWithStartPoint:CGPointMake(_view7.frame.origin.x, _view7.frame.origin.y + _view7.frame.size.height / 2) andEndPoint:CGPointMake(_view4.frame.origin.x + _view4.frame.size.width, _view4.frame.origin.y + _view4.frame.size.height / 2) andControl:CGPointMake(_view4.frame.origin.x + _view4.frame.size.width + 20, _view4.frame.origin.y + _view4.frame.size.height / 2) andColor:[UIColor colorWithHex:@"#737373"]];
    [self.view.layer addSublayer:shapeLayer7_4];
    
    CGPoint shapeLayer7_4jiantouPoint = CGPointMake(_view4.frame.origin.x + _view4.frame.size.width, _view4.frame.origin.y + _view4.frame.size.height / 2);
    CAShapeLayer *shapeLayer7_4jiantou = [self jiantou:shapeLayer7_4jiantouPoint andFirstLine:CGPointMake(shapeLayer7_4jiantouPoint.x + 4, shapeLayer7_4jiantouPoint.y - 2) andSecondLine:CGPointMake(shapeLayer7_4jiantouPoint.x + 4, shapeLayer7_4jiantouPoint.y + 2) andColor:[UIColor colorWithHex:@"#737373"]];
    [self.view.layer addSublayer:shapeLayer7_4jiantou];
    
    //无兜底话术-肯定
    CAShapeLayer *shapeLayer7_5 = [self configBezierPathWithStartPoint:CGPointMake(_view7.frame.origin.x, _view7.frame.origin.y + _view7.frame.size.height / 2) andEndPoint:CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2) andColor:[UIColor colorWithHex:@"#737373"]];
    [self.view.layer addSublayer:shapeLayer7_5];
    
    CGPoint shapeLayer7_5jiantouPoint = CGPointMake(_view5.frame.origin.x + _view5.frame.size.width, _view5.frame.origin.y + _view5.frame.size.height / 2);
    CAShapeLayer *shapeLayer7_5jiantou = [self jiantou:shapeLayer7_5jiantouPoint andFirstLine:CGPointMake(shapeLayer7_5jiantouPoint.x, shapeLayer7_5jiantouPoint.y - 4) andSecondLine:CGPointMake(shapeLayer7_5jiantouPoint.x + 3, shapeLayer7_5jiantouPoint.y+3) andColor:[UIColor colorWithHex:@"#737373"]];
    [self.view.layer addSublayer:shapeLayer7_5jiantou];
}

//MARK:-导线箭头
- (CAShapeLayer *)jiantou:(CGPoint)point andFirstLine:(CGPoint)firstPoint andSecondLine:(CGPoint)secondPoint andColor:(UIColor *)color {
    UIBezierPath *path1 = [[UIBezierPath alloc]init];
    path1.lineWidth = 2;
    [[UIColor blueColor] setFill];
    [path1 moveToPoint:CGPointMake(point.x, point.y)];
    [path1 addLineToPoint:firstPoint];
    [path1 addLineToPoint:secondPoint];
    [path1 stroke];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    /// 设置layer的填充颜色  -- 会覆盖贝塞尔曲线设置的填充颜色,最终显示为无色
    shapeLayer.fillColor = color.CGColor;
    /// 设置曲线的绘制路线颜色
    shapeLayer.strokeColor = color.CGColor;
    /// 将曲线的路径添加到layer上
    shapeLayer.path = path1.CGPath;
    return shapeLayer;
}
//MARK:-三阶导线
- (CAShapeLayer *)configBezierPathWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint andControl1:(CGPoint)control1Point andControl2:(CGPoint)control2Point andColor:(UIColor *)color {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    path.lineWidth = 2;
    [[UIColor blueColor]setStroke];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:endPoint controlPoint1:control1Point controlPoint2:control2Point];
    [path stroke];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    /// 设置layer的填充颜色  -- 会覆盖贝塞尔曲线设置的填充颜色,最终显示为无色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    /// 设置曲线的绘制路线颜色
    shapeLayer.strokeColor = color.CGColor;
    /// 将曲线的路径添加到layer上
    shapeLayer.path = path.CGPath;
    return shapeLayer;
}
//MARK:-二阶导线
- (CAShapeLayer *)configBezierPathWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint andControl:(CGPoint)controlPoint andColor:(UIColor *)color {
    UIBezierPath *path4 = [[UIBezierPath alloc]init];
    path4.lineWidth = 2;
    [[UIColor blueColor]setStroke];
    [path4 moveToPoint:startPoint];
    [path4 addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    [path4 stroke];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    /// 设置layer的填充颜色  -- 会覆盖贝塞尔曲线设置的填充颜色,最终显示为无色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    /// 设置曲线的绘制路线颜色
    shapeLayer.strokeColor = color.CGColor;
    /// 将曲线的路径添加到layer上
    shapeLayer.path = path4.CGPath;
    return shapeLayer;
}
//MARK:-导线
- (CAShapeLayer *)configBezierPathWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint andColor:(UIColor *)color {
    UIBezierPath *path4 = [[UIBezierPath alloc]init];
    path4.lineWidth = 2;
    [[UIColor blueColor]setStroke];
    [path4 moveToPoint:startPoint];
    [path4 addLineToPoint:endPoint];
    [path4 stroke];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    /// 设置layer的填充颜色  -- 会覆盖贝塞尔曲线设置的填充颜色,最终显示为无色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    /// 设置曲线的绘制路线颜色
    shapeLayer.strokeColor = color.CGColor;
    /// 将曲线的路径添加到layer上
    shapeLayer.path = path4.CGPath;
    return shapeLayer;
}

//MARK:-编辑话术
- (void)editButtonAction:(UIButton *)sender {
    MJKMessageMapEditViewController *vc = [[MJKMessageMapEditViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
