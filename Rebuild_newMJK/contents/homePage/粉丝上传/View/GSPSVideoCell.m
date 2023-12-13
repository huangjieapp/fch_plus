//
//  GSPSVideoCell.m
//  GAVideoRecordDemo
//
//  Created by Gamin on 2019/3/11.
//  Copyright © 2019年 Gamin. All rights reserved.
//

#import "GSPSVideoCell.h"
#import "GSRecordVideoController.h"
#import "UIViewController+NoSlideBack.h"
#import "GSRecordEngine.h"
#import <CoreServices/CoreServices.h>
#import "MJKOldCustomerSalesModel.h"
#import "VideoAndImageModel.h"

@interface GSPSVideoCell ()<GSRecordVideoControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *videoImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) UIImagePickerController *moviePicker; // 视频选择器
@property (strong, nonatomic) GSRecordEngine *recordEngine;
/** <#注释#> */
@property (nonatomic,strong) NSMutableArray *localUrlArray;
@property (nonatomic,strong) NSMutableArray *imageViewArray;
/** <#注释#> */
@property (nonatomic,strong) NSArray *localArr;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *fileListGzVideo;


@end

@implementation GSPSVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    scrollView.frame = CGRectMake(0, 0, KScreenWidth, 120);
    [self.videoBG addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.mas_equalTo(0);
//    }];
    
    UIButton *addButton = [[UIButton alloc]init];
    self.addButton = addButton;
    addButton.tag = 101010;
    addButton.frame  =  CGRectMake(10, 10, 100, 100);
    [scrollView addSubview:addButton];
//    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(10);
//        make.width.height.mas_equalTo(100);
//    }];
    [addButton setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(tapAddVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)tapAddVideoAction:(UIButton *)sender {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.rootVC presentViewController:self.moviePicker animated:YES completion:nil];
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       GSRecordVideoController *con = GSRecordVideoController.new;
       con.hidesBottomBarWhenPushed = YES;
       con.delegate = self;
       [self.rootVC presentViewController:con animated:YES completion:nil];
    }]];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.rootVC presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOldModel:(MJKOldCustomerSalesModel *)oldModel  {
    _oldModel = oldModel;
    [self.localUrlArray removeAllObjects];
    [self.fileListGzVideo removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (VideoAndImageModel *model in oldModel.fileListGzVideo) {
            GSPSVideoModel *vmodel = [[GSPSVideoModel alloc]init];
            vmodel.videoLocalPath = model.url;
            vmodel.videoFirstImg = [self getVideoFirstViewImage:[NSURL URLWithString:model.url]];
            CGFloat timeSecs = [self getVideoDuration:[NSURL URLWithString:model.url]];
            NSString *timeFormat = [self Timeformat2FromSeconds:timeSecs];
            vmodel.videoTimeFormat = timeFormat;
            [self.localUrlArray addObject:vmodel];
            [self.fileListGzVideo addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.localArr =  self.localUrlArray;
        });
    });
    
}

// 获取视频第一帧
- (UIImage*)getVideoFirstViewImage:(NSURL *)path {
  
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
  AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  
  assetGen.appliesPreferredTrackTransform = YES;
  CMTime time = CMTimeMakeWithSeconds(0.0, 600);
  NSError *error = nil;
  CMTime actualTime;
  CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
  UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
  CGImageRelease(image);
  return videoImage;
  
}

- (void)setLocalArr:(NSArray *)localArr {
    _localArr = localArr;
    [self.imageViewArray removeAllObjects];
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != 101010) {
            [view removeFromSuperview];
        }
    }
    DBSelf(weakSelf);
    for (int i = 0; i < localArr.count; i++) {
        GSPSVideoModel *model = localArr[i];
        UIView *bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(10 + (110 * i), 10, 100, 100);
        [self.scrollView addSubview:bgView];
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(10);
//            make.width.height.mas_equalTo(weakSelf.addButton);
//            make.left.mas_equalTo(10 + (110 * i));
//        }];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:model.videoFirstImg];
        imageView.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
        [bgView addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.left.right.mas_equalTo(bgView);
//        }];
        UIButton *button = [[UIButton alloc]init];
        button.frame = CGRectMake((bgView.frame.size.width - 30) / 2, (bgView.frame.size.height - 30) / 2, 30, 30);
        [bgView addSubview:button];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_equalTo(imageView).mas_offset((100 - 30) / 2);
//            make.width.height.mas_equalTo(30);
//        }];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_image_jsviedo"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(bgView.frame.size.width - 5 - 20, 5, 20, 20)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"icon_module_general_close"] forState:UIControlStateNormal];
        deleteButton.tag = 10 + i;
        [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        
        [bgView addSubview:deleteButton];
        
        [self.imageViewArray addObject:bgView];
    }
    CGRect addFrame = self.addButton.frame;
    addFrame.origin.x = localArr.count * 110 + 10;
    self.addButton.frame = addFrame;
//    [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(localArr.count * 110 + 10);
//    }];
    self.scrollView.contentSize = CGSizeMake(localArr.count * 110 + 10 + 110, 100);
    
    
}

- (void)videoPlay:(UIButton *)sender {
    UIView *bgView = self.imageViewArray[sender.tag - 100];
    UIImageView *imageView;
    for (UIView *view in bgView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)view;
        }
    }
    GSPSVideoModel *model = self.localUrlArray[sender.tag - 100];
    if (self.delegate && [self.delegate respondsToSelector:@selector(GSPSVideoCell_PlayClickWithPath:)]) {
        [self.delegate GSPSVideoCell_PlayClickWithPath:model.videoLocalPath];
    }
    
    if (model.videoLocalPath != nil && ![model.videoLocalPath isEqualToString:@""]) {
        NSString *urlPath = model.videoLocalPath;
        if (![self theString:urlPath containSting:@"http://"] && ![self theString:urlPath containSting:@"https://"]) {
            if (![self theString:urlPath containSting:@"file://"]) {
                urlPath = [NSString stringWithFormat:@"file://%@",urlPath];
            }
        }
        
//        NSIndexPath *_curIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self setupPlayerViewWithIndex:self.indexPath andView:bgView Path:urlPath First:YES];
    }
}

- (void)delete:(UIButton *)sender {
    [self.localUrlArray removeObjectAtIndex:sender.tag - 10];
    [self.fileListGzVideo removeObjectAtIndex:sender.tag - 10];
    self.localArr = self.localUrlArray;
}

- (BOOL)theString:(NSString *)str containSting:(NSString *)string {
    if (str && [str rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (IBAction)tapPlayButtonAction:(id)sender {
    
}

// 设置播放器
- (void)setupPlayerViewWithIndex:(NSIndexPath *)index andView:(UIView *)view Path:(NSString *)path First:(BOOL)first {
    GASLPlayer *sharePlayer = [GASLPlayer sharedGASLPlayerMethod];
    SLPlayerView *playerView = sharePlayer.playerView;
    UITableView *collView = (UITableView *)[self superview];
    playerView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view addSubview:playerView];
//    [playerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(view);
//        make.left.mas_equalTo(view);
//        make.right.mas_equalTo(view);
//        make.bottom.mas_equalTo(view);
//    }];
    if (first) {
        SLPlayerModel *playerModel = [[SLPlayerModel alloc] init];
        playerModel.videoURL       = [NSURL URLWithString:path];
        playerModel.scrollView     = collView;
        playerModel.indexPath      = index;
        playerModel.fatherViewTag  = 200;
        [sharePlayer playWithPlayerModel:playerModel];
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"GSPSVideoCell";
    GSPSVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

#pragma mark - 懒加载
- (GSRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[GSRecordEngine alloc] init];
    }
    return _recordEngine;
}

- (UIImagePickerController *)moviePicker {
    if (_moviePicker == nil) {
        _moviePicker = [[UIImagePickerController alloc] init];
        _moviePicker.delegate = self;
        [_moviePicker configNoSlideBack];
        _moviePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _moviePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        _moviePicker.allowsEditing = YES;
        _moviePicker.videoMaximumDuration = GS_Video_Limit_Seconds;
    }
    return _moviePicker;
}

#pragma mark - GSRecordVideoControllerDelegate
// 录像
- (void)handleWithRecordPath:(NSString *)recordPath withFirstImage:(UIImage *)firstImage withTotalTimeFormat:(NSString *)totalTimeFormat {
    GSPSVideoModel *videoModel = GSPSVideoModel.new;
    videoModel.videoLocalPath = recordPath;
    videoModel.videoFirstImg = firstImage;
    videoModel.videoTimeFormat = totalTimeFormat;
    [self.localUrlArray addObject:videoModel];
//    self.videoModel = videoModel;
//    [self.tableView reloadData];
    [self httpUpdateQiniuWithUrl:recordPath];
}

#pragma mark - UIImagePickerControllerDelegate
// 选择视频
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        // 获取视频的名称
        NSString *videoPath = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerMediaURL]];
        // 如果视频是mov格式的则转为MP4的
        if ([videoPath containsString:@".MOV"]) {
            NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
            CGFloat timeSecs = [self getVideoDuration:videoUrl];
            
            NSString *timeFormat = [self Timeformat2FromSeconds:timeSecs];
            DBSelf(weakSelf);
            [self.recordEngine changeMovToMp4:videoUrl dataBlock:^(UIImage *movieImage) {
                [weakSelf.moviePicker dismissViewControllerAnimated:YES completion:^{
                    [self handleWithRecordPath:weakSelf.recordEngine.videoPath withFirstImage:movieImage withTotalTimeFormat:timeFormat];
                }];
            }];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 其它
// 获取视频时间
- (CGFloat)getVideoDuration:(NSURL *)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

// 获取视频 大小
- (NSInteger)getFileSize:(NSString *)path {
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) ) {
            return  [theFileSize intValue]/1024;
        } else {
            return -1;
        }
    } else {
        return -1;
    }
}

// 秒数格式化
- (NSString *)Timeformat2FromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time;
    if ([str_hour isEqualToString:@"00"]) {
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    return format_time;
}

- (void)httpUpdateQiniuWithUrl:(NSString *)videoUrl {
    DBSelf(weakSelf);
    NSData *data = [NSData dataWithContentsOfFile:videoUrl];
    NSString *mimeType = [videoUrl pathExtension];
    NSString *fileNameStr = [videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataQiNiuUpDataFileWithUrl:HTTP_UploadByQiNiu parameters:nil file:data andFileName:fileNameStr andMimeType:mimeType compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            VideoAndImageModel *model = [VideoAndImageModel mj_objectWithKeyValues:data];
            [weakSelf.fileListGzVideo addObject:model];
            if (weakSelf.urlBackBlock) {
                weakSelf.urlBackBlock(model);
            }
            weakSelf.localArr = weakSelf.localUrlArray;
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (NSMutableArray *)localUrlArray {
    if (!_localUrlArray) {
        _localUrlArray = [NSMutableArray array];
    }
    return _localUrlArray;
}

- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (NSMutableArray *)fileListGzVideo {
    if (!_fileListGzVideo) {
        _fileListGzVideo = [NSMutableArray array];
    }
    return _fileListGzVideo;
}
@end
