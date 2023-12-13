//
//  CollectionViewCell.m
//  CoffeeCloud
//
//  Created by FishYu on 2017/10/20.
//  Copyright © 2017年 coffee. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CGCIntegralModel.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius=self.img.layer.cornerRadius=4;
    self.layer.masksToBounds=self.img.layer.masksToBounds=YES;
    // Initialization code
}

- (void)reloadCellWithModel:(CGCIntegralModel *)model{
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.smallpicture]];
    self.titLab.text=model.name;
    self.numLab.text=model.awardfactor1;
    
}

@end
