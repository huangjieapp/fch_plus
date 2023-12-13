//
//  HeadImageView.m
//  uliaobao
//
//  Created by pop on 15/6/16.
//  Copyright (c) 2015年 CGC. All rights reserved.
//

#import "HeadImageView.h"
#import "RFLayout.h"

@interface HeadImageView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView * collectionView;
//@property(nonatomic,assign)  NSTimer*timer;
@property (nonatomic,assign)NSInteger move;


@end
@implementation HeadImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self makeData];
        [self makeCollectionView];
    }
    return self;
}
- (void)makeData
{
    self.dataArray = [[NSMutableArray alloc] init];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
  
    [self.collectionView reloadData];
}

- (void)makecurentView
{
    self.pageControl.numberOfPages = self.dataArray.count;
    if (self.dataArray.count>1) {
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:self.dataArray];
        [tempArray insertObject:[self.dataArray objectAtIndex:([self.dataArray count]-1)] atIndex:0];
        [tempArray addObject:[self.dataArray objectAtIndex:0]];
        self.dataArray= tempArray;
        [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    }
    if (self.dataArray.count==1) {
        self.collectionView.scrollEnabled = NO;
    }else{
        if (self.isUserTouch) {
            
        }else{
            _timer=[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            
        }
       
    }
    [self.collectionView reloadData];
    self.pageControl.hidden = !self.showPageControl;
}
- (void)makeCollectionView
{
    self.collectionView = [self creatCollectionViewWithFram:self.bounds WithitemSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) withReuseIdentifierClass:[UICollectionViewCell class] idName:@"IDS" scrollViewDirection:UICollectionViewScrollDirectionHorizontal WithImageEdes:UIEdgeInsetsZero isONeView:YES];
  
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    UIPageControl * pageC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, WIDE, 20)];
    self.pageControl = pageC;
//    self.pageControl.currentPageIndicatorTintColor = COLOR_43AAFF08;
//    self.pageControl.pageIndicatorTintColor = COLOR_33333308;
    pageC.numberOfPages = 1;
    pageC.currentPage = 0;
    [self addSubview:pageC];
   
    
   }
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IDS" forIndexPath:indexPath];
    UIImageView * view = (UIImageView*)[cell viewWithTag:10];
   
    if (view==nil) {
        view = [[UIImageView alloc] initWithFrame:self.bounds];
             view.tag = 10;
        [cell addSubview:view];
    }
     view.contentMode = self.imageMode;
    UIImage * image = [UIImage imageNamed:@"默认图-横版"];
    if (self.ploadImage) {
        image = self.ploadImage;
    }
    cell.clipsToBounds=YES;
    
  
//    [view sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:image];
    [view sd_setImageWithURL:[NSURL URLWithString:  self.dataArray[indexPath.row]] placeholderImage:image];
    
  
//    view.image=[UIImage imageNamed:@"self.dataArray[indexPath.row]"];
    
    if(self.isShowWater==YES){
//        UIImageView *subViewImage=(UIImageView *)[cell viewWithTag:888];
//        if(subViewImage==nil){
//            subViewImage=[[UIImageView alloc]initWithFrame:CGRectMake((WIDE-290)/2, (WIDE-115)/2, 260, 85)];
//            subViewImage.tag=888;
//            subViewImage.image=[UIImage imageNamed:@"Combined Shape"];
//            [view addSubview:subViewImage];
//        }
    }
    
    
//    view.image=[UIImage imageNamed:@"3-1"];
    NSLog(@"%ld-=-=",(long)indexPath.row);
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.deleagte respondsToSelector:@selector(headView:didSelectItemAtIndexPath:)]) {
        if (self.dataArray.count==1) {
            [self.deleagte headView:self didSelectItemAtIndexPath:indexPath];
        }else{
            if (indexPath.row==0) {
                [self.deleagte headView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count-2 inSection:0]];
            }else if(indexPath.row == self.dataArray.count-1){
                [self.deleagte headView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            }else{
                [self.deleagte headView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row-1 inSection:0]];
            }
        }
    }
}


- (BOOL)isUrlString {
    
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
    
}


-(void)onTimer{
    
    _move++;
    NSLog(@"dafdsafsd0-0---00-0-----   %d",_move);
    if (_move>=([self.dataArray count]-1)) {
       [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y)];
        [self.collectionView setContentOffset:CGPointMake(WIDE, self.collectionView.contentOffset.y) animated:YES];
        _move = 1;
    }else{
        [self.collectionView setContentOffset:CGPointMake(_move*WIDE, self.collectionView.contentOffset.y)animated:YES];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    
    NSLog(@"dafdsafsd   %ld-=-==-%f",(long)_move,scrollView.contentOffset.x);
    
    if (_move==-1) {
        [scrollView setContentOffset:CGPointMake(([self.dataArray count]-2)*WIDE, self.collectionView.contentOffset.y)];
    }
    if (_move==([self.dataArray count]-2)) {
        [scrollView setContentOffset:CGPointMake(WIDE, self.collectionView.contentOffset.y)];
    }
    
    
    
   
    
}
#pragma mark- scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) ;
    _move=page;
    if ([self.deleagte respondsToSelector:@selector(nowpag:)]) {
        if (page-1<0) {
            page+=1;
        }else if (page-1>=self.dataArray.count-2){
            page = 1;
        }
        
        [self.deleagte nowpag:page-1];
        
    }
    
  
    
    self.currentPage = page;
    self.pageControl.currentPage = page;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.dataArray.count==1) {
        self.collectionView.scrollEnabled = NO;

    }else{
      
            [_timer setFireDate:[NSDate distantFuture]];
     
        
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.dataArray.count==1) {
        self.collectionView.scrollEnabled = NO;
    }else{
       
            [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];;
       
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UICollectionView*)creatCollectionViewWithFram:(CGRect)frame WithitemSize:(CGSize)size withReuseIdentifierClass:(Class)className idName:(NSString*)identifier scrollViewDirection:(UICollectionViewScrollDirection)scrollDirection WithImageEdes:(UIEdgeInsets)inset isONeView:(BOOL)one
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = size;
    layout.scrollDirection = scrollDirection;
    layout.sectionInset = inset;
    if (one) {
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
    }
    layout.minimumInteritemSpacing = 0;
    UICollectionView * collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    if (className) {
        [collection registerClass:className forCellWithReuseIdentifier:identifier];
    }
    
    collection.backgroundColor = [UIColor whiteColor];
    return collection;
}


@end
