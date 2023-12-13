//
//  MJKReportNewTableViewCell.m
//  Rebuild_newMJK
//
//  Created by Mcr on 2018/4/17.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKReportNewTableViewCell.h"
#import "MJKReportCollectionViewCell.h"


@interface MJKReportNewTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate>

//@property (nonatomic, strong) UICollectionViewLayout *customLayout;
@end

@implementation MJKReportNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize=CGSizeMake((KScreenWidth - 40) / 4, (KScreenWidth - 40) / 4);
//    flowLayout.minimumInteritemSpacing=ACTUAL_HEIGHT(9);
//    flowLayout.minimumLineSpacing=ACTUAL_HEIGHT(5+4);
    flowLayout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
//    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, (KScreenWidth / 4) * 2) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    // 注册cell、sectionHeader、sectionFooter
    [_collectionView registerNib:[UINib nibWithNibName:@"MJKReportCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerNib:[UINib nibWithNibName:@"MJKReportCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId1"];
//    [_collectionView  registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId"];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isTopTableView == YES) {
        MJKReportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        cell.contentLabel.hidden  = YES;
        cell.imageView.hidden = NO;
        cell.imageView.image = [UIImage imageNamed:self.dataArr[indexPath.row][@"image"]];
        cell.titleLabel.text = self.dataArr[indexPath.row][@"title"];
        return cell;
    } else {
        MJKReportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId1" forIndexPath:indexPath];
        cell.contentLabel.hidden  = NO;
        cell.imageView.hidden = YES;
        cell.contentLabel.text = self.dataArr[indexPath.row][@"content"];
        cell.titleLabel.text = self.dataArr[indexPath.row][@"title"];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *str = self.dataArr[indexPath.row][@"isDidSelect"];
//    if (str.length > 0) {
//        if (self.backDidSelectBlock) {
//            self.backDidSelectBlock(indexPath);
//        }
//    }
    if ([self.delegate respondsToSelector:@selector(collectionDidSelectItem:andTitle:andIsTop:)]) {
        [self.delegate collectionDidSelectItem:indexPath andTitle:self.dataArr[indexPath.row][@"title"] andIsTop:self.isTopTableView];
    }
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKReportNewTableViewCell";
    MJKReportNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}



@end
