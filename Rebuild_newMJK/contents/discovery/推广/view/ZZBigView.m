//
//  ZZBigView.m
//  uliaobao
//
//  Created by wisdom on 16/6/20.
//  Copyright © 2016年 CGC. All rights reserved.
//

#import "ZZBigView.h"
#import "ZZSubBigView.h"

@interface ZZBigView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,ZZSubBigViewDelegate>

@property (nonatomic, strong)NSArray *urlArr;

@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *imgArr;

@property (nonatomic, strong)UICollectionView *mycollectionView;

@property (nonatomic, strong)ZZSubBigView *bgView;



@end

@implementation ZZBigView


- (instancetype)initWithFrame:(CGRect)frame withURLs:(NSArray *)urlArr with:(NSInteger)indexrow{
    
    if(self=[super initWithFrame:frame]){
        
        self.backgroundColor=[UIColor blackColor];
        
        self.page=indexrow;
        
        [self createTap];
        
        self.urlArr=urlArr;
        
        [self createCollection];
        

        
     
    }
    return self;
}




/**
 *  添加手势
 */

- (void)createTap{
    UITapGestureRecognizer * tap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1; //tap次数
    tap.delegate=self;
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *bacTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bacTap:)];
    bacTap.numberOfTapsRequired=2;
    bacTap.delegate=self;
    
    [self addGestureRecognizer:bacTap];
    //如果不加下面的话，当单指双击时，会先调用单指单击中的处理，再调用单指双击中的处理
    
    [tap requireGestureRecognizerToFail:bacTap];
    
   


}

- (void)tap:(UITapGestureRecognizer*)tap{
    
    [self removeFromSuperview];
}

/**
 *  点击两次返回原图
 *
 *  @param tap
 */

- (void)bacTap:(UITapGestureRecognizer*)tap{



    CGFloat newZoomScale = 1.0f;
    newZoomScale = MAX(newZoomScale, 1.0);
    [self.bgView.myScroll setZoomScale:newZoomScale animated:YES];
    
    self.mycollectionView.scrollEnabled=YES;



}

- (void)show{
    
    [[[UIApplication sharedApplication]keyWindow ] addSubview:self];

}


- (void)createCollection
{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.itemSize=CGSizeMake(WIDE, HIGHT);
    layout.sectionInset=UIEdgeInsetsZero;
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;//水平
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing=0;
    
    UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator=NO;
    collectionView.backgroundColor=[UIColor blackColor];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.bounces=NO;
    collectionView.pagingEnabled=YES;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
    [collectionView setContentOffset:CGPointMake(0, 0)];
    self.mycollectionView=collectionView;
    [self addSubview:collectionView];
    [self.mycollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.page inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.bigPageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, HIGHT-36, WIDE, 6)];
    self.bigPageControl.numberOfPages=self.urlArr.count;
    self.bigPageControl.currentPage=self.page;
    self.bigPageControl.currentPageIndicatorTintColor=COLOR_43AAFF08;
    self.bigPageControl.pageIndicatorTintColor=COLOR_33333308;
    [self addSubview:self.bigPageControl];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urlArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"ID";
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.bgView=[[ZZSubBigView alloc]initWithdelegate:self withframe:CGRectMake(0, 0, WIDE, HIGHT) withURL:self.urlArr[indexPath.row]];
    self.bgView.tag = 1000;
    [[cell viewWithTag:1000] removeFromSuperview];
    [cell.contentView addSubview:self.bgView];
 
    return cell;
}

- (void)getScale:(ZZSubBigView *)subView goWith:(CGFloat)scale{
    if(scale==1){
        self.mycollectionView.scrollEnabled=YES;
    }
}

- (void)stopCollection:(ZZSubBigView *)subView{
//    self.mycollectionView.scrollEnabled=NO;
    
    self.mycollectionView.scrollEnabled=YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

   
  
    self.page=self.mycollectionView.contentOffset.x/WIDE;

    
    self.bigPageControl.currentPage=self.page;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
