//
//  CollectionViewCell.h
//  CoffeeCloud
//
//  Created by FishYu on 2017/10/20.
//  Copyright © 2017年 coffee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCIntegralModel;

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (weak, nonatomic) IBOutlet UILabel *numLab;


- (void)reloadCellWithModel:(CGCIntegralModel *)model;
@end
