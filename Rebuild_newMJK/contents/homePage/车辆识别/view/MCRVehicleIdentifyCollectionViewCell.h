//
//  MCRVehicleIdentifyCollectionViewCell.h
//  Mcr_2
//
//  Created by Mcr on 2018/12/7.
//  Copyright © 2018 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCRVehicleIdentifyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labState;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *vehicleLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;

@end

NS_ASSUME_NONNULL_END
