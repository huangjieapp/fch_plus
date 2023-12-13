//
//  MJKApplicationTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKApplicationTableViewCell.h"
#import "MJKApplicationCollectionViewCell.h"
#import "MJKManagerModuleModel.h"



#define CCELL0   @"MJKApplicationCollectionViewCell"
@interface MJKApplicationTableViewCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UILabel*titleLab;
@property(nonatomic,strong)UICollectionView*collectionView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation MJKApplicationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, KScreenWidth/2, 16)];
        self.titleLab.textColor=DBColor(176, 176, 176);
        self.titleLab.font=[UIFont systemFontOfSize:14];
        self.titleLab.text=@"标题";
        [self.contentView addSubview:self.titleLab];
        
        //创建collectionView   30地方开始  上偏移10
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize=CGSizeMake(ACTUAL_WIDTH(82), ACTUAL_HEIGHT(54));
        flowLayout.sectionInset=UIEdgeInsetsMake(10, 5, 10, 5);
        flowLayout.minimumInteritemSpacing=8;
        flowLayout.minimumLineSpacing=8;
        
        UICollectionView*collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, KScreenWidth, self.height-30) collectionViewLayout:flowLayout];
        collectionView.dataSource=self;
        collectionView.delegate=self;
        collectionView.scrollEnabled=NO;
        collectionView.backgroundColor=[UIColor whiteColor];
        self.collectionView=collectionView;
        [collectionView registerNib:[UINib nibWithNibName:CCELL0 bundle:nil] forCellWithReuseIdentifier:CCELL0];
        [self.contentView addSubview:collectionView];

        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
        [collectionView addGestureRecognizer:_longPress];
       
        
    }
    
    return self;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MJKApplicationCollectionViewCell*ccell=[collectionView dequeueReusableCellWithReuseIdentifier:CCELL0 forIndexPath:indexPath];
    MJKManagerModuleModel*model=self.allDatas[indexPath.row];
    ccell.model=model;
    ccell.appType=self.appType;
    ccell.isSelected=self.isSelected;
    
    
    return ccell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
		MJKManagerModuleModel*model=self.allDatas[indexPath.row];
	if ([model.name isEqualToString:@"更多应用"]) {
		if (self.showEditButtonBlock) {
			self.showEditButtonBlock();
		}
		[self.allDatas removeLastObject];
		[self.collectionView reloadData];
	} else if (self.appType==ApplicationTypeMyApp) {
			if (self.isSelected==YES) {
				//删除应用
				NSMutableArray*array=[[KUSERDEFAULT objectForKey:SaveSelectedModule] mutableCopy];
				if (array.count<=1) {
					[JRToast showWithText:@"最少保留一个我的应用"];
					return;
				}
				
				for (int i=0; i<array.count; i++) {
					if ([array[i] isEqualToString:model.name]) {
						[array removeObjectAtIndex:i];
					}
				}
				
				[KUSERDEFAULT setObject:array forKey:SaveSelectedModule];
				[KUSERDEFAULT synchronize];
				if (self.fatherReloadBlock) {
					self.fatherReloadBlock(@"noMoreCollection");
				}
				
			}else{
				//跳转   传入name 和自己的view  来跳转。
				
                UIViewController*mainVC=[DBTools getSuperViewWithsubView:self.contentView];
                [DBObjectTools pushVCWithName:model.name andSelf:mainVC];
				
				
			}
			
			
		}else if (self.appType==ApplicationTypeModule){
			
			
			if (self.isSelected==YES) {
//                if (model.isBuy == NO) {
//                    if (![[NewUserSession instance].hotappList containsObject:model.code]) {
//                        [JRToast showWithText:@"不是热门并且未购买"];
//                        return;
//                    }
//                }
//				if (![[NewUserSession instance].hotappList containsObject:model.code] && model.isBuy == NO) {
//					[JRToast showWithText:@"不是热门并且未购买"];
//					return;
//				}
				//判断是否能添加  能添加 就添加
				if (model.isSelected) {
					[JRToast showWithText:@"已选择"];
				}else{
					NSMutableArray*array=[[KUSERDEFAULT objectForKey:SaveSelectedModule] mutableCopy];
					//                if (array.count>=8) {
					//                    [JRToast showWithText:@"最多选择8个"];
					//                }else{
					[array addObject:model.name];
					[KUSERDEFAULT setObject:array forKey:SaveSelectedModule];
					[KUSERDEFAULT synchronize];
					if (self.fatherReloadBlock) {
						self.fatherReloadBlock(@"noMoreCollection");
					}
					
					
					
					//                }
					
				}
				
				
			}else{
//                if (![[NewUserSession instance].hotappList containsObject:model.code] && model.isBuy == NO) {
//                    [JRToast showWithText:@"不是热门并且未购买"];
//                    return;
//                }
				//跳转
                UIViewController*mainVC=[DBTools getSuperViewWithsubView:self.contentView];
                [DBObjectTools pushVCWithName:model.name andSelf:mainVC];
				
			}
			
			
		}
	
	
    
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame=CGRectMake(0, 30, KScreenWidth, self.height-30);
    
}


#pragma mark  --click
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress
{
    if (!self.canMove||self.appType==ApplicationTypeModule) {
        return;
    }
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                // 找到当前的cell
                MJKApplicationCollectionViewCell *cell = (MJKApplicationCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
                // 定义cell的时候btn是隐藏的, 在这里设置为NO
//                [cell.btnDelete setHidden:NO];
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            break;
        }
        default: [self.collectionView cancelInteractiveMovement];
            break;
    }
}


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
    // 找到当前的cell
    MJKApplicationCollectionViewCell *cell = (MJKApplicationCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
//    [cell.btnDelete setHidden:YES];
//    [self.array exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
//    [self.collectionView reloadData];
    if (self.completeMoveBlock) {
        self.completeMoveBlock(sourceIndexPath, destinationIndexPath);
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}

#pragma mark  --set
-(void)setAllDatas:(NSMutableArray *)allDatas{
    _allDatas=allDatas;
    [self.collectionView reloadData];
    
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.titleLab.text=titleStr;
    
}


-(void)setIsSelected:(BOOL)isSelected{
    _isSelected=isSelected;
    [self.collectionView reloadData];

}





#pragma mark  --funcation
+(CGFloat)calculateCellHeight:(NSMutableArray*)array{
    NSInteger reallySection;
    NSInteger number=array.count;
    NSInteger section=number/4;
    NSInteger row=number%4;
    if (row==0) {
        reallySection=section;
    }else{
        reallySection=section+1;
    }
    
    
    return 30+reallySection*(10+ACTUAL_HEIGHT(52))+10;
    
}


@end
