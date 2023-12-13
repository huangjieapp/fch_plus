//
//  ZZSubBigView.m
//  uliaobao
//
//  Created by wisdom on 16/6/21.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "ZZSubBigView.h"

@interface ZZSubBigView()<UIScrollViewDelegate>




@property (nonatomic, strong)UIImageView *urlImageView;

@property (nonatomic, strong)UIImageView *subViewImage;

@property (nonatomic, copy) NSString* imgUrl;

@end

@implementation ZZSubBigView



- (instancetype)initWithdelegate:(id<ZZSubBigViewDelegate>)delegate withframe:(CGRect)frame withURL:(NSString *)url{
    if (self=[super initWithFrame:frame]) {
        
        self.delegate=delegate;
        self.imgUrl=url;
        self.backgroundColor=[UIColor blackColor];
        [self createView];
        
    }
    return self;
}


- (void)createView{
    
  
    self.myScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT+80)];
    self.myScroll.backgroundColor=[UIColor blackColor];
    self.myScroll.delegate=self;
    self.myScroll.minimumZoomScale=1.0;
    self.myScroll.maximumZoomScale=2.0;
    self.myScroll.bouncesZoom=NO;
    [self centerScrollViewContents];
    [self addSubview:self.myScroll];
    
    
    
    
    
    self.urlImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT)];
    self.urlImageView.contentMode=UIViewContentModeScaleAspectFit;
    self.urlImageView.userInteractionEnabled=YES;
    [self.myScroll addSubview:self.urlImageView];
    
    
    self.myScroll.contentSize=CGSizeMake(self.urlImageView.bounds.size.width, self.urlImageView.bounds.size.height);
//    if([self.imgUrl rangeOfString:@"_800"].location!=NSNotFound){
//        [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:[self.imgUrl stringByReplacingOccurrencesOfString:@"_400" withString:@"_800"]] placeholderImage:[UIImage imageNamed:@"600_600"]];
//    }else
//    {
//        [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"600_600"]];
//    }
    
     [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"600_600"]];

    
    


//    self.subViewImage=[[UIImageView alloc]initWithFrame:CGRectMake((WIDE-290)/2, (WIDE-115)/2, 260, 85)];
//    self.subViewImage.image=[UIImage imageNamed:@"Combined Shape"];
//            
//    [self.urlImageView addSubview: self.subViewImage];
    
    
    

}



- (void)centerScrollViewContents {
    CGSize boundsSize = self.myScroll.bounds.size;
    CGRect contentsFrame = self.urlImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
        
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f-40;
        
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.urlImageView.frame = contentsFrame;
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    /**
     *  在中间缩放
     */
    [self centerScrollViewContents];



}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    [self.delegate stopCollection:self];
    
    return scrollView.subviews[0];
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*scale, scrollView.frame.size.height*scale-200*scale);
    
    [self.delegate getScale:self goWith:scale];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
