//
//  XMGTopicPictureView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "CGCExpandModel.h"

@implementation XMGTopicPictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)pictureView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (IBAction)moreButtonAction:(UIButton *)sender {
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
}
- (void)setExpand:(CGCExpandModel *)expand{
    
    NSInteger number=expand.images.count;
    
    for (int i=0; i<number; i++) {
        CGFloat x=10;
        
        CGFloat w=(WIDE-70 - 60)/3;
        CGFloat h=w;
        int j=0;
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        if (i<3) {
            j=i;
        }else{
            j=i%3;
        }
        CGFloat y=(i/3+1)*10+i/3*h;
        btn.frame=CGRectMake(60 + x*(1+j)+w*j, y + 100, w, h);
        //        NSLog(@"%f-=-=%f=====%d===%d===%d_+_+%d===%d===%d",x,y,2/3,3/3,4/3,3%3,4%3,5%3);
     
        [btn setTitleColor:COLOR_333333 forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14.0];
        
        
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.width, btn.height)];
        
        [img sd_setImageWithURL:[NSURL URLWithString:expand.images[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
           
         
        }];
        
        //        [btn setImage:self.imgArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        [btn addSubview:img];
        [self addSubview:btn ];
        
    }
    
    
//
}
- (void)btnClick:(UIButton *)btn{
    
    if (self.pBlock) {
        self.pBlock(btn.tag, btn.titleNormal);
    }
    
}


    

@end
