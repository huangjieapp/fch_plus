//
//  SHHomePageThirdTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHHomePageThirdTableViewCell.h"
#import "HPThirdCellCollectionViewCell.h"

#import "MJKManagerModuleViewController.h"



#import "scribeCustomLabelViewController.h"

#pragma mark - joyce.huang
#import "MJKClueListViewController.h"


//#import "HomeSelectApplicationViewController.h"   //所有的跳转
#import "CGCAppointmentListVC.h"




#define CCELL0   @"HPThirdCellCollectionViewCell"

@interface SHHomePageThirdTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end

@implementation SHHomePageThirdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(70), ACTUAL_HEIGHT(50));
    flowLayout.sectionInset=UIEdgeInsetsMake(ACTUAL_HEIGHT(5), ACTUAL_WIDTH(12), 0, ACTUAL_WIDTH(12));
    flowLayout.minimumLineSpacing=ACTUAL_WIDTH(10);
    flowLayout.minimumInteritemSpacing=ACTUAL_WIDTH(8);
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, [SHHomePageThirdTableViewCell getCellHeight]) collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:CCELL0 bundle:nil] forCellWithReuseIdentifier:CCELL0];
    
    self.collectionView.scrollEnabled=NO;
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatas.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HPThirdCellCollectionViewCell*ccell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    MJKManagerModuleModel*model=self.allDatas[indexPath.row];
    ccell.headImageView.image=[UIImage imageNamed:model.imageName];
    ccell.titleLabel.text=model.name;
    if ([model.name isEqualToString:@"工作圈"]) {
        if (self.isHaveDot == 1) {
            [ccell.headImageView pp_addDotWithColor:[UIColor redColor]];
        }
    }
    
    
    return ccell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    MJKManagerModuleModel*model=self.allDatas[indexPath.row];
    NSString*str=model.name;
    
    [self touchWithStr:str];


    
    
}


#pragma mark  --touch
-(void)touchWithStr:(NSString*)str{
    UIViewController*mainVC=[DBTools getSuperViewWithsubView:self.contentView];
	if ([str isEqualToString:@"更多应用"]) {
		
		
		MJKManagerModuleViewController*vc=[[MJKManagerModuleViewController alloc]init];
		[mainVC.navigationController pushViewController:vc animated:YES];
	} else {
        [DBObjectTools pushVCWithName:str andSelf:mainVC];
//		[DBObjectTools pushVCWithName:str andSelfView:self.contentView];
	}
	


}


#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
	static NSString *ID = @"SHHomePageThirdTableViewCell";
	SHHomePageThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	return cell;
	
}





#pragma mark  -- set




+(CGFloat)getCellHeight{
	NSArray*saveModule=[[NSUserDefaults standardUserDefaults] objectForKey:@"module"];
	NSInteger count = (saveModule.count + 1) / 4;
	NSInteger re = (saveModule.count + 1) % 4;
//	NSInteger line = 1;
//	line = line + count;
//    if (re == 0) {
//        return ACTUAL_HEIGHT(50 * count);
//    } else {
//        return ACTUAL_HEIGHT(50 * (count + 1));
//    }
	return ACTUAL_HEIGHT((60) * ((re == 0) ? count : (count + 1)));
	
//    return ACTUAL_HEIGHT(70+12);
	
//    return 145+20;
}
@end
