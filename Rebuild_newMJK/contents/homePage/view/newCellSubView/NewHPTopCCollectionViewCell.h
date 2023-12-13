//
//  NewHPTopCCollectionViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NextCountModel.h"
#import "subDicNextCountModel.h"


@interface NewHPTopCCollectionViewCell : UICollectionViewCell

-(void)inputValue:(NextCountModel*)mainModel;
@property(nonatomic,strong)NextCountModel*mainModel;


@property(nonatomic,strong)void(^clickButtonBlock)(subDicNextCountModel*subModel,NSString*TypeName);

@end
