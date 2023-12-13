//
//  GSPSVideoCell.h
//  GAVideoRecordDemo
//
//  Created by Gamin on 2019/3/11.
//  Copyright © 2019年 Gamin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPSVideoModel.h"
@class MJKOldCustomerSalesModel;
@class VideoAndImageModel;

NS_ASSUME_NONNULL_BEGIN

static NSString * const GSPSVideoCellIdentifier = @"GSPSVideoCell";

@protocol GSPSVideoCellDelegate <NSObject>

@optional

- (void)GSPSVideoCell_PlayClickWithPath:(NSString *)playPath;

@end

@interface GSPSVideoCell : UITableViewCell
/** <#注释#> */
@property (nonatomic,strong) MJKOldCustomerSalesModel *oldModel;

@property (weak, nonatomic) IBOutlet UIView *maskV;
@property (nonatomic, strong) GSPSVideoModel *videoModel;
@property (nonatomic, weak) id <GSPSVideoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *videoBG;
/** <#注释#> */
@property (nonatomic,strong) NSIndexPath *indexPath;
/** <#注释#> */
@property(nonatomic, assign) UIViewController *rootVC;
/** <#注释#> */
//@property (nonatomic,copy) void(^urlBackBlock)(NSArray *arr);
@property (nonatomic,copy) void(^urlBackBlock)(VideoAndImageModel *model);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
