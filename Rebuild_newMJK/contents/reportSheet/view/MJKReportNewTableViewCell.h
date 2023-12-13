//
//  MJKReportNewTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Mcr on 2018/4/17.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MJKReportNewTableViewCellDelegate<NSObject>
- (void)collectionDidSelectItem:(NSIndexPath *)indexPath andTitle:(NSString *)name andIsTop:(BOOL)isTop;
@end

@interface MJKReportNewTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
/** 传dic，并且如果collection可点击则dic中传isDidSelect*/
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) void (^backDidSelectBlock)(NSIndexPath *indexPathC);
@property (nonatomic, weak) id<MJKReportNewTableViewCellDelegate>delegate;
@property (nonatomic, assign) BOOL isTopTableView;
@end
