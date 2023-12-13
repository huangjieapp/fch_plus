//
//  MJKScoialMarketHeaderView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKScoialMarketHeaderView.h"
#import "MJKSocialMarketHeaderModel.h"

@interface MJKScoialMarketHeaderView ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *showCountLabelCollection;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *searchTimeButtonCollection;
@property (weak, nonatomic) IBOutlet UIView *searchTimeView;

@property (weak, nonatomic) IBOutlet UILabel *readMpNumber;
@property (weak, nonatomic) IBOutlet UILabel *readScNumber;
@property (weak, nonatomic) IBOutlet UILabel *readHdNumber;
@property (weak, nonatomic) IBOutlet UILabel *readSpNumber;
@property (weak, nonatomic) IBOutlet UILabel *participateActivityNumber;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *customerNumber;
@property (weak, nonatomic) IBOutlet UILabel *purchaseGoodsnumber;
@property (weak, nonatomic) IBOutlet UILabel *shareNumber;
@property (weak, nonatomic) IBOutlet UILabel *readNumber;
@property (weak, nonatomic) IBOutlet UILabel *readCount;
@property (weak, nonatomic) IBOutlet UILabel *forwardNumber;


@end

@implementation MJKScoialMarketHeaderView

static UIButton *preButton;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, KScreenWidth - 20, 44);  // 设置显示的frame
    gradientLayer.colors = @[(id)[UIColor lightGrayColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor lightGrayColor].CGColor];  // 设置渐变颜色
    //    gradientLayer.locations = @[@0.0, @0.2, @0.5];    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);   //
    gradientLayer.endPoint = CGPointMake(0, 1);     //
    [self.searchTimeView.layer addSublayer:gradientLayer];
    
    
    UIButton *searchButton = self.searchTimeButtonCollection[0];
    [searchButton setTitleColor:[UIColor blackColor]];
    [searchButton setBackgroundColor:[UIColor whiteColor]];
    preButton = searchButton;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = KScreenWidth;
    frame.size.height = ((KScreenWidth - 50) / 4) * 2 + 154;
    [super setFrame:frame];
}

- (IBAction)searchTimeButtonAction:(UIButton *)sender {
    [sender setTitleColor:[UIColor blackColor]];
    [sender setBackgroundColor:[UIColor whiteColor]];
    [preButton setTitleColor:[UIColor whiteColor]];
    [preButton setBackgroundColor:[UIColor clearColor]];
    preButton = sender;
    if (self.searchTimeActionBlock) {
        self.searchTimeActionBlock(sender);
    }
}

- (void)setNumberModel:(MJKSocialMarketHeaderModel *)numberModel {
    _numberModel = numberModel;
    self.readMpNumber.text = numberModel.readMpNumber;
    self.readScNumber.text = numberModel.readScNumber;
    self.readHdNumber.text = numberModel.readHdNumber;
    self.readSpNumber.text = numberModel.readSpNumber;
    self.participateActivityNumber.text = numberModel.participateActivityNumber;
    self.phoneNumber.text = numberModel.phoneNumber;
    self.customerNumber.text = numberModel.customerNumber;
    self.purchaseGoodsnumber.text = numberModel.purchaseGoodsNumber;
    self.shareNumber.text = numberModel.shareNumber;
    self.readNumber.text = numberModel.readNumber;
    self.readCount.text = numberModel.readCount;
    self.forwardNumber.text = numberModel.forwardNumber;
}

@end
