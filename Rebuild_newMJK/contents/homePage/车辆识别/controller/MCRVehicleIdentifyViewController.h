//
//  MCRVehicleIdentifyViewController.h
//  Mcr_2
//
//  Created by Mcr on 2018/12/7.
//  Copyright © 2018 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCRVehicleIdentifyViewController : DBBaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView4;
@property (weak, nonatomic) IBOutlet UIView *OperationView;
@property (strong, nonatomic) IBOutlet UIView *BGView;

@property (strong, nonatomic) IBOutlet UILabel *labCountYX;//有效
@property (strong, nonatomic) IBOutlet UIImageView *labBGYX;

@property (strong, nonatomic) IBOutlet UILabel *labCountPC;//批次
@property (strong, nonatomic) IBOutlet UIImageView *labBGPC;

@property (strong, nonatomic) IBOutlet UILabel *labCountCL;//未处理
@property (strong, nonatomic) IBOutlet UIImageView *labBGCL;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
//@property(nonatomic,strong)UICollectionView* collectionView;

@property (strong, nonatomic) IBOutlet UIView *chuangjianView;
@property (strong, nonatomic) IBOutlet UITextField *chaungjianStartime;

@property (strong, nonatomic) IBOutlet UITextField *chaungjianEndTime;
- (IBAction)chaungjianCancel:(id)sender;
- (IBAction)chaungjianSure:(id)sender;
@property(nonatomic,strong)NSString* path;
@property(nonatomic,strong)NSMutableArray* pathArr;
@property(nonatomic,strong)NSMutableArray* ImgArr;
@property(nonatomic,strong)NSString* tag;
@property(nonatomic,assign)NSInteger path_tag;

@property(nonatomic,strong)NSString* Arrival_type;

@end

NS_ASSUME_NONNULL_END
