//
//  SHNewHomePageFirstTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHNewHomePageFirstTableViewCell.h"
#import "SHBoardView.h"
#import "NewHPTopCCollectionViewCell.h"

#import "CGCOrderListVC.h"//订单管理
#import "PotentailCustomerListViewController.h"//客户管理
#import "CGCAppointmentListVC.h"//预约管理

#import "WorkCalendartListViewController.h"



#import "scribeCustomLabelViewController.h"   //测试用的

#import "MJKClueListViewController.h"


#define CCELL0   @"NewHPTopCCollectionViewCell"

@interface SHNewHomePageFirstTableViewCell()<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UIImageView*portraitImageView;
@property(nonatomic,strong)UILabel*titleLabel;


@property(nonatomic,strong)UIScrollView*topScrollView;
@property(nonatomic,strong)UIPageControl*pageControl;
@property(nonatomic,strong)UICollectionView*collectionView;  //


@property(nonatomic,strong)NSMutableArray*saveThreeBoardArray;  //保存3个board 的数组 1000  1001 1002


@property(nonatomic,strong)NSMutableArray*collectionAllDatas;

@end

@implementation SHNewHomePageFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView*portraitImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 30, 30)];
        self.portraitImageView=portraitImageView;
        portraitImageView.layer.cornerRadius=6;
        portraitImageView.layer.masksToBounds=YES;
        [portraitImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar] placeholderImage:[UIImage imageNamed:@"icon_set_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        [self.contentView addSubview:portraitImageView];
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, KScreenWidth-60-10, 16)];
        self.titleLabel=titleLabel;
        titleLabel.text=[NSString stringWithFormat:@"%@",[NewUserSession instance].user.nickName];
        titleLabel.centerY=portraitImageView.centerY;
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textColor=DBColor(169, 169, 169);
        [self.contentView addSubview:titleLabel];
        
        
        
        //创建scrollView
        UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, ACTUAL_HEIGHT(48), KScreenWidth, ACTUAL_HEIGHT(85))];
        self.topScrollView=scrollView;
        scrollView.delegate=self;
//        scrollView.backgroundColor=[UIColor redColor];
        scrollView.contentSize=CGSizeMake(4*KScreenWidth, 0);
        scrollView.bounces=NO;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.pagingEnabled=YES;
        [self.contentView addSubview:scrollView];
        for (int i=0; i<4; i++) {
            SHBoardView*boardView=[SHBoardView boardView];
            boardView.frame=CGRectMake(KScreenWidth*i, 0, KScreenWidth, ACTUAL_HEIGHT(75));
            boardView.tag=1000+i;
            [scrollView addSubview:boardView];
            [self.saveThreeBoardArray addObject:boardView];
            
            if (isiPhone5) {
                scrollView.height=75;
                boardView.height=75;
                
            }
            
            
            
            
            
        }
        
        //3个pageControl
        self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(KScreenWidth-80, 35,10, 10)];
        self.pageControl.size=CGSizeMake(20, 5);
//        self.pageControl.backgroundColor=[UIColor greenColor];
        self.pageControl.numberOfPages=4;
        self.pageControl.currentPage=0;
        self.pageControl.pageIndicatorTintColor=DBColor(60, 60, 60);
        self.pageControl.currentPageIndicatorTintColor=DBColor(107, 243, 206);
        [self.contentView addSubview:self.pageControl];
        
        
        if (isiPhone5) {
            self.pageControl.frame=CGRectMake(KScreenWidth-35, 32, 10, 10);
            
        }
        
//        50+act75 的地方  开始

        
        //collectionView
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize=CGSizeMake(KScreenWidth, ACTUAL_HEIGHT(58));
        flowLayout.minimumInteritemSpacing=ACTUAL_HEIGHT(9);
        flowLayout.minimumLineSpacing=ACTUAL_HEIGHT(5+4);
        flowLayout.sectionInset=UIEdgeInsetsMake(ACTUAL_HEIGHT(10), ACTUAL_WIDTH(10), 0, 0);
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        
        UICollectionView*collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 50+ACTUAL_WIDTH(85), KScreenWidth, ACTUAL_HEIGHT(210)) collectionViewLayout:flowLayout];
        self.collectionView=collectionView;
        collectionView.backgroundColor=DBColor(248, 248, 248);
        collectionView.dataSource=self;
        collectionView.delegate=self;
        [self.contentView addSubview:collectionView];
        [self.collectionView registerClass:[NewHPTopCCollectionViewCell class] forCellWithReuseIdentifier:CCELL0];
        
        
        
        
    }
    return self;
    
}

#pragma mark--  collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectionAllDatas.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewHPTopCCollectionViewCell*ccell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    NextCountModel*model=self.collectionAllDatas[indexPath.section];
    
    DBSelf(weakSelf);
//    UIViewController*superVC=[DBTools getSuperViewWithsubView:self];
    ccell.clickButtonBlock = ^(subDicNextCountModel *subModel, NSString *TypeName) {
        MyLog(@"%@,%@",subModel.NAME,TypeName);
        
        [DBObjectTools homePagePushVCWithTimeType:TypeName andName:subModel.NAME andSelfView:self.contentView];
        
        
    };
    
    
    [ccell inputValue:model];
    
    
    return ccell;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark  --delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat scrollX= scrollView.contentOffset.x;
    CGFloat i=scrollX/KScreenWidth;
    self.pageControl.currentPage=i;
}


#pragma mark  --set
-(NSMutableArray *)saveThreeBoardArray{
    if (!_saveThreeBoardArray) {
        _saveThreeBoardArray=[NSMutableArray array];
    }
    return _saveThreeBoardArray;
}



#pragma mark  -- function
+(CGFloat)getCellHeight{
//    124+
//    MyLog(@"%lu",50+ACTUAL_WIDTH(75)+ACTUAL_HEIGHT(196));
    
    return ACTUAL_HEIGHT(50)+ACTUAL_WIDTH(75)+ACTUAL_HEIGHT(215);
//    return 320;
}

-(void)getTopValue:(MJKJXModel*)model andNextValue:(NSMutableArray*)mtArray {
	SHBoardView*boardView0= [self.topScrollView viewWithTag:1003];
	SHBoardView*boardView1= [self.topScrollView viewWithTag:1002];
	SHBoardView*boardView2= [self.topScrollView viewWithTag:1001];
	SHBoardView*boardView3= [self.topScrollView viewWithTag:1000];
	
#pragma view0
	boardView0.leftTopLabel.text=@"名单新增";
	boardView0.leftTopToday.text = model.XS_MB;;
	boardView0.leftTopMonth.text= model.XS_JRCOUNT;
	boardView0.rightTopLabel.text = model.XS_MIDCOUNT;
	boardView0.rightTopToday.text = model.XS_BL;
    boardView0.rightTopToday.textColor = [model.XS_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView0.rightTopMonth.text =  model.XS_WCL;
    boardView0.rightTopMonth.textColor = [model.XS_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView0.topJRBtn.tag = 111;
    [boardView0.topJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView0.topMonBtn.tag = 112;
    [boardView0.topMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
	
	boardView0.leftBottomLabel.text=@"邀约到店";
	boardView0.leftBottomToday.text = model.YY_MB;
	boardView0.leftBottomMonth.text=model.YY_JRCOUNT;
	boardView0.rightBottomLabel.text = model.YY_MIDCOUNT;
	boardView0.rightBottomToday.text = model.YY_BL;
    boardView0.rightBottomToday.textColor = [model.YY_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView0.rightBottomMonth.text = model.YY_WCL;
    boardView0.rightBottomMonth.textColor = [model.YY_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView0.bottomJRBtn.tag = 113;
    [boardView0.bottomJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView0.bottomMonBtn.tag = 114;
    [boardView0.bottomMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
	
	
#pragma view1
	boardView1.leftTopLabel.text=@"客户新增";
	boardView1.leftTopToday.text = model.QK_MB;
	boardView1.leftTopMonth.text=model.QK_JRCOUNT;
	boardView1.rightTopLabel.text = model.QK_MIDCOUNT;
	boardView1.rightTopToday.text = model.QK_BL;
    boardView1.rightTopToday.textColor = [model.QK_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView1.rightTopMonth.text = model.QK_WCL;
    boardView1.rightTopMonth.textColor = [model.QK_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView1.topJRBtn.tag = 107;
    [boardView1.topJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView1.topMonBtn.tag = 108;
    [boardView1.topMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    
	
	boardView1.leftBottomLabel.text=@"客户跟进";
	boardView1.leftBottomToday.text = model.GJ_MB;
	boardView1.leftBottomMonth.text=model.GJ_JRCOUNT;
	boardView1.rightBottomLabel.text = model.GJ_MIDCOUNT;
	boardView1.rightBottomToday.text = model.GJ_BL;
    boardView1.rightBottomToday.textColor = [model.GJ_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView1.rightBottomMonth.text = model.GJ_WCL;
    boardView1.rightBottomMonth.textColor = [model.GJ_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView1.bottomJRBtn.tag = 109;
    [boardView1.bottomJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView1.bottomMonBtn.tag = 110;
    [boardView1.bottomMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
	
	
#pragma view2
	boardView2.leftTopLabel.text=@"预估金额";
	boardView2.leftTopToday.text = model.DDYG_MB;
	boardView2.leftTopMonth.text=model.DDYG_JRCOUNT;
	boardView2.rightTopLabel.text = model.DDYG_MIDCOUNT;
	boardView2.rightTopToday.text = model.DDYG_BL;
    boardView2.rightTopToday.textColor = [model.DDYG_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView2.rightTopMonth.text = model.DDYG_WCL;
    boardView2.rightTopMonth.textColor = [model.DDYG_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView2.topJRBtn.tag = 100;
    [boardView2.topJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView2.topMonBtn.tag = 102;
    [boardView2.topMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
	
	boardView2.leftBottomLabel.text=@"回款金额";
	boardView2.leftBottomToday.text = model.DDHK_MB;
	boardView2.leftBottomMonth.text=model.DDHK_JRCOUNT;
	boardView2.rightBottomLabel.text = model.DDHK_MIDCOUNT;
	boardView2.rightBottomToday.text = model.DDHK_BL;
    boardView2.rightBottomToday.textColor = [model.DDHK_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView2.rightBottomMonth.text = model.DDHK_WCL;
    boardView2.rightBottomMonth.textColor = [model.DDHK_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView2.bottomJRBtn.tag = 103;
    [boardView2.bottomJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView2.bottomMonBtn.tag = 104;
    [boardView2.bottomMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
	
#pragma view3
	boardView3.leftTopLabel.text=@"订单新增";
	boardView3.leftTopToday.text = model.DD_MB;
	boardView3.leftTopMonth.text=model.DD_JRCOUNT;
	boardView3.rightTopLabel.text = model.DD_MIDCOUNT;
	boardView3.rightTopToday.text = model.DD_BL;
    boardView3.rightTopToday.textColor = [model.DD_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView3.rightTopMonth.text = model.DD_WCL;
    boardView3.rightTopMonth.textColor = [model.DD_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView3.topJRBtn.tag = 100;
    [boardView3.topJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView3.topMonBtn.tag = 102;
    [boardView3.topMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    
	
	boardView3.leftBottomLabel.text=@"订单完工";
	boardView3.leftBottomToday.text = model.DDJF_MB;
	boardView3.leftBottomMonth.text=model.DDJF_JRCOUNT;
	boardView3.rightBottomLabel.text = model.DDJF_MIDCOUNT;
	boardView3.rightBottomToday.text = model.DDJF_BL;
    boardView3.rightBottomToday.textColor = [model.DDJF_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
	boardView3.rightBottomMonth.text = model.DDJF_WCL;
    boardView3.rightBottomMonth.textColor = [model.DDJF_WCL_FLAG isEqualToString:@"UP"] ? [UIColor greenColor] : [UIColor redColor];
    boardView3.bottomJRBtn.tag = 105;
    [boardView3.bottomJRBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
    boardView3.bottomMonBtn.tag = 106;
    [boardView3.bottomMonBtn addTarget:self action:@selector(gotoMoudleButton:) forControlEvents:UIControlEventTouchUpInside];
	
	
	
	self.collectionAllDatas=mtArray;
	[self.collectionView reloadData];
	
	
}

- (void)gotoMoudleButton:(UIButton *)sender {
    UIViewController*mainVC=[DBTools getSuperViewWithsubView:self];
    if (sender.tag == 100) {//订单新增和预估金额的今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.createTimeType = @"1";
		vc.IS_ASSISTANT = @"0";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 102) {//订单新增和预估金额的本月
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.createTimeType = @"3";
		vc.IS_ASSISTANT = @"0";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 103) {//回款今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.QUEREN_TIME_TYPE = @"1";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 104) {//回款本月
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.QUEREN_TIME_TYPE = @"3";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 105) {//订单交付今日
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.SEND_TIME_TYPE = @"1";
		vc.IS_ASSISTANT = @"0";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 106) {//订单交付本月
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        vc.SEND_TIME_TYPE = @"3";
		vc.IS_ASSISTANT = @"0";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 107) {//客户新增今日
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.CREATE_TIME = @"1";
		vc.FOLLOW_TIME_TYPE = @"9";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 108) {//今日新增本月
        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        vc.CREATE_TIME = @"3";
		vc.FOLLOW_TIME_TYPE = @"9";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 109) {//客户跟进今日
//        PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
//        vc.NEWFOLLOW_TIME_TYPE = @"1";
//        [mainVC.navigationController pushViewController:vc animated:YES];
		
		WorkCalendartListViewController*vc=[[WorkCalendartListViewController alloc]init];
		vc.C_TYPE_DD_ID = @"0";
		vc.CREATE_TIME_TYPE = @"1";
		[mainVC.navigationController pushViewController:vc animated:YES];
		
    } else if (sender.tag == 110) {//客户跟进本月
		WorkCalendartListViewController*vc=[[WorkCalendartListViewController alloc]init];
		vc.C_TYPE_DD_ID = @"0";
		vc.CREATE_TIME_TYPE = @"3";
		[mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 111) {//线索新增今日
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        mjkClueVC.CREATE_TIME_TYPE = @"1";
        [mainVC.navigationController pushViewController:mjkClueVC animated:YES];
    } else if (sender.tag ==112) {//线索新增本月
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        mjkClueVC.CREATE_TIME_TYPE = @"3";
        [mainVC.navigationController pushViewController:mjkClueVC animated:YES];
    } else if (sender.tag == 113) {//邀约到店今日
        CGCAppointmentListVC * vc=[[CGCAppointmentListVC alloc] init];
        vc.ARRIVE_TIME_TYPE = @"1";
        vc.IS_ARRIVE_SHOP = @"2";
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 114) {//邀约到店本月
        CGCAppointmentListVC * vc=[[CGCAppointmentListVC alloc] init];
        vc.ARRIVE_TIME_TYPE = @"3";
        vc.IS_ARRIVE_SHOP = @"2";
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
}


//-(void)getTopValue:(TopCountModel*)model  andNextValue:(NSMutableArray*)mtArray{
//   SHBoardView*boardView0= [self.topScrollView viewWithTag:1003];
//   SHBoardView*boardView1= [self.topScrollView viewWithTag:1002];
//   SHBoardView*boardView2= [self.topScrollView viewWithTag:1001];
//	SHBoardView*boardView3= [self.topScrollView viewWithTag:1000];
//
//#pragma view0
//    boardView0.leftTopLabel.text=@"线索";
//    NSString*xs_flag=model.XS_FLAG;
//    NSString*xs_jrcount=model.XS_JRCOUNT;
//    NSString*xs_BL=model.XS_BL;
//    NSString*xs_monthCount=model.XS_MIDCOUNT;
//    NSMutableAttributedString*value= [self inputJRCount:xs_jrcount andflag:xs_flag andBL:xs_BL];
//    boardView0.leftTopToday.attributedText=value;
//    boardView0.leftTopMonth.text=xs_monthCount;
//
//    boardView0.leftBottomLabel.text=@"来电";
//    NSString*ld_flag=model.LD_FLAG;
//    NSString*ld_jrcount=model.LD_JRCOUNT;
//    NSString*ld_bl=model.LD_BL;
//    NSString*ld_monthCount=model.LD_MIDCOUNT;
//    boardView0.leftBottomToday.attributedText= [self inputJRCount:ld_jrcount andflag:ld_flag andBL:ld_bl];
//    boardView0.leftBottomMonth.text=ld_monthCount;
//
//    boardView0.rightTopLabel.text=@"自媒体";
//    boardView0.rightTopToday.attributedText=[self inputJRCount:model.ZMT_JRCOUNT andflag:model.ZMT_FLAG andBL:model.ZMT_BL];
//    boardView0.rightTopMonth.text=model.ZMT_MIDCOUNT;
//
//    boardView0.rightBottomLabel.text=@"流量";
//    boardView0.rightBottomToday.attributedText=[self inputJRCount:model.LL_JRCOUNT andflag:model.LL_FLAG andBL:model.LL_BL];
//    boardView0.rightBottomMonth.text=model.LL_MIDCOUNT;
//
//
//
//#pragma view1
//    boardView1.leftTopLabel.text=@"客户";
//    boardView1.leftTopToday.attributedText=[self inputJRCount:model.QK_JRCOUNT andflag:model.QK_FLAG andBL:model.QK_BL];
//    boardView1.leftTopMonth.text=model.QK_MIDCOUNT;
//
//    boardView1.leftBottomLabel.text=@"跟进";
//    boardView1.leftBottomToday.attributedText=[self inputJRCount:model.GJ_JRCOUNT andflag:model.GJ_FLAG andBL:model.GJ_BL];
//    boardView1.leftBottomMonth.text=model.GJ_MIDCOUNT;
//
//    boardView1.rightTopLabel.text=@"战败";
//    boardView1.rightTopToday.attributedText=[self inputJRCount:model.ZB_JRCOUNT andflag:model.ZB_FLAG andBL:model.ZB_BL];
//    boardView1.rightTopMonth.text=model.ZB_MIDCOUNT;
//
//    boardView1.rightBottomLabel.text=@"预约";
//    boardView1.rightBottomToday.attributedText=[self inputJRCount:model.YY_JRCOUNT andflag:model.YY_FLAG andBL:model.YY_BL];
//    boardView1.rightBottomMonth.text=model.YY_MIDCOUNT;
//
//
//#pragma view2
//    boardView2.leftTopLabel.text=@"定金";
//    boardView2.leftTopToday.attributedText=[self inputJRCount:model.BJ_JRCOUNT andflag:model.BJ_FLAG andBL:model.BJ_BL];
//    boardView2.leftTopMonth.text=model.BJ_MIDCOUNT;
//
//    boardView2.leftBottomLabel.text=@"交付";
//    boardView2.leftBottomToday.attributedText=[self inputJRCount:model.JF_JRCOUNT andflag:model.JF_FLAG andBL:model.JF_BL];
//    boardView2.leftBottomMonth.text=model.GJ_MIDCOUNT;
//
//    boardView2.rightTopLabel.text=@"签约";
//    boardView2.rightTopToday.attributedText=[self inputJRCount:model.DD_JRCOUNT andflag:model.DD_FLAG andBL:model.DD_BL];
//    boardView2.rightTopMonth.text=model.DD_MIDCOUNT;
//
//    boardView2.rightBottomLabel.text=@"退单";
//    boardView2.rightBottomToday.attributedText=[self inputJRCount:model.QX_JRCOUNT andflag:model.QX_FLAG andBL:model.QX_BL];
//    boardView2.rightBottomMonth.text=model.QX_MIDCOUNT;
//
//#pragma view3
//	boardView3.leftTopLabel.text=@"订单新增";
//	boardView3.leftTopToday.attributedText=[self inputJRCount:model.BJ_JRCOUNT andflag:model.BJ_FLAG andBL:model.BJ_BL];
//	boardView3.leftTopMonth.text=model.BJ_MIDCOUNT;
//
//	boardView3.leftBottomLabel.text=@"订单交付";
//	boardView3.leftBottomToday.attributedText=[self inputJRCount:model.JF_JRCOUNT andflag:model.JF_FLAG andBL:model.JF_BL];
//	boardView3.leftBottomMonth.text=model.GJ_MIDCOUNT;
//
//
//
//    self.collectionAllDatas=mtArray;
//    [self.collectionView reloadData];
//
//
//}


-(NSMutableAttributedString*)inputJRCount:(NSString*)jrCount andflag:(NSString*)flag andBL:(NSString*)BL{
    
    NSString*arrStr;
    UIColor*arrColor;
    if ([flag isEqualToString:@"0"]) {
        arrStr=@" ";
        arrColor=[UIColor blackColor];
    }else if ([flag isEqualToString:@"UP"]){
        arrStr=@"↑";
        arrColor=[UIColor redColor];
    }else if ([flag isEqualToString:@"DOWN"]){
        arrStr=@"↓";
        arrColor=[UIColor greenColor];
    }
    
    NSString*presentBL;
    if ([BL isEqualToString:@"0%"]) {
        presentBL=@"--";
        
    }else{
        presentBL=BL;
    }
    
    
   
    if (jrCount.length<6) {
        NSInteger number=6-jrCount.length;
        for (int i=0; i<number; i++) {
            [jrCount stringByAppendingString:@" "];
        }
   
        
    }

    jrCount=[@"   " stringByAppendingString:jrCount];
    
    
    
    NSString*XS_BL=presentBL;
    NSString*BLandArr=[NSString stringWithFormat:@"    %@%@",XS_BL,arrStr];
    
    NSMutableAttributedString*aaa=[[NSMutableAttributedString alloc]initWithString:jrCount attributes:@{NSForegroundColorAttributeName:DBColor(78, 78, 78)}];
    NSMutableAttributedString*bbb=[[NSMutableAttributedString alloc]initWithString:BLandArr attributes:@{NSForegroundColorAttributeName:arrColor}];
    [aaa appendAttributedString:bbb];

    
    return aaa;
}


@end
