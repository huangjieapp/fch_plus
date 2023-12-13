//
//  MJKExpandPictureViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKExpandPictureViewController.h"

#import "CGCExpandModel.h"

#import "ZZBigView.h"

@interface MJKExpandPictureViewController ()
/** <#注释#>*/
@property (nonatomic, strong) CGCExpandModel *model;
@end

@implementation MJKExpandPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"素材详情";
    
    
}

- (instancetype)initWithModel:(CGCExpandModel *)model {
    if (self = [super init]) {
        self.model = model;
        [self configUIWithModel:model];
        
    }
    return self;
}

- (void)configUIWithModel:(CGCExpandModel *)model {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight)];
    [self.view addSubview:scrollView];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:model.salespicture] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    [scrollView addSubview:headImageView];
    
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMinY(headImageView.frame), 100, 20)];
    nameLabel.text = model.salesname;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    [scrollView addSubview:nameLabel];
    
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(KScreenWidth - 90, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMaxY(nameLabel.frame), KScreenWidth - 90, size.height + 10)];
    contentLabel.text = model.content;
    contentLabel.textColor = [UIColor darkGrayColor];
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    contentLabel.numberOfLines = 0;
    [scrollView addSubview:contentLabel];
    
    if ([model.type isEqualToString:@"2"]) {
        for (int i = 0; i < model.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                CGFloat height = image.size.height / (image.size.width / KScreenWidth);
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame) + 10 + (i * height), KScreenWidth, height);
                    if (i == model.images.count - 1) {
                        scrollView.contentSize = CGSizeMake(KScreenWidth, imageView.frame.size.height + imageView.frame.origin.y);
                    }
                });
            }];
            [scrollView addSubview:imageView];
        }
    } else {
        CGFloat margin = headImageView.frame.size.width + headImageView.frame.origin.x + 10;
        CGFloat space = 10;
        CGFloat width = (KScreenWidth - margin - 20 - 2 * 10) / 3;
        CGFloat height = width;
        //    NSInteger number = model.images.count;
        UIImageView *lastIamgeView;
        for (int i = 0; i < model.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(margin + ((i % 3) * (width + space)), CGRectGetMaxY(contentLabel.frame) + (i / 3) * (height + space), width, height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[i]]];
            [scrollView addSubview:imageView];
            
            UIButton *button = [[UIButton alloc]initWithFrame:imageView.frame];
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(showBigImage:)];
            [scrollView addSubview:button];
            
            if (i == model.images.count - 1) {
                lastIamgeView = imageView;
                
            }
        }
        
        UIButton *addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addressButton setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
        CGFloat addressWidth = [model.addressName boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
        addressButton.frame = CGRectMake(margin, CGRectGetMaxY(lastIamgeView.frame) , addressWidth, model.addressName.length > 0 ? 30 : 0);
        [addressButton setTitleNormal:model.addressName];
        
        addressButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        [scrollView addSubview:addressButton];
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(addressButton.frame), CGRectGetMaxY(addressButton.frame), 150, 30)];
        timeLabel.textColor = [UIColor darkGrayColor];
        timeLabel.text = model.time;
        timeLabel.font = [UIFont systemFontOfSize:14.f];
        [scrollView addSubview:timeLabel];
        
        scrollView.contentSize = CGSizeMake(KScreenWidth, timeLabel.frame.size.height + timeLabel.frame.origin.y);
    }
    
    
}

- (void)showBigImage:(UIButton *)sender {
    ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:self.model.images with:sender.tag - 1000];
    
    [bigView show];
}

@end
