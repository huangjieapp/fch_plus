//
//  MJKShootView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKShootView.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MJKShootView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
/** add button*/
@property (nonatomic, strong) UIButton *addButton;

/** video imageview*/
@property (nonatomic, strong) UIImageView *videoImageView;
/* <# 注释 #> **/
@property (nonatomic,strong) NSString *videoUrl;
/* <# 注释 #> **/
@property (nonatomic,strong) NSString *fileName;
/* <# 注释 #> **/
@property (nonatomic,strong) NSURL *outputURL;
/** rootVC*/
@property (nonatomic, weak) UIViewController *rootVC;
@end

@implementation MJKShootView

- (instancetype)initWithFrame:(CGRect)frame andVC:(UIViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootVC = vc;
        
        CGFloat width = self.frame.size.width / 3;
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, width - 20, width - 20)];
        self.addButton = addButton;
        //    [button setImage:@"icon_add"];
        [addButton setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [self addSubview:addButton];
        [addButton addTarget:self action:@selector(takePhotoOrSelectPicture)];
    }
    return self;
}

#pragma mark - 播放
- (void)showVideo:(UITapGestureRecognizer *)tapGR {
    
}

#pragma mark - 删除视频
- (void)deleteVideo:(UIButton *)sender {
    [self.videoImageView removeFromSuperview];
    [self deleteFile];
    if (self.imageFrameBlock) {
        self.imageFrameBlock(self.addButton.frame,[NSData data]);
    }
    if (self.videoDataBlock) {
        self.videoDataBlock([NSData data]);
    }
}


#pragma mark - 选取照片或者拍照
- (void)takePhotoOrSelectPicture
{
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"录像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self startvideo];
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choosevideo];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertSheet addAction:actionOne];
    [alertSheet addAction:actionTwo];
    [alertSheet addAction:cancelAction];
    
    [self.rootVC presentViewController:alertSheet animated:YES completion:nil];
}


//从相册中选取
- (void)choosevideo
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    
    [self.rootVC presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//设置委托
}

//录制视频
- (void)startvideo
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    //    ipc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    ipc.videoQuality = UIImagePickerControllerQualityTypeHigh;//设置清晰度
    [self.rootVC presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 600.0f;//10分钟
    ipc.delegate = self;//设置委托
    
    
}


//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

//此方法可以获取视频文件的时长。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

//完成视频录制，并压缩后显示大小、时长
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:sourceURL]]);
    NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
    
    NSURL *newVideoUrl ; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    formater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    _fileName = [NSString stringWithFormat:@"output-%@.mp4", [formater stringFromDate:[NSDate date]]];
    
    NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSString * urlStr = [url path];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
        //        UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
    //放一张视频图片显示
    UIImage *image = [self thumbnailImageForVideo:sourceURL atTime:0];
    NSData *firstImageData = UIImageJPEGRepresentation(image, 0.1);
    
    
    CGFloat s = image.size.width / self.addButton.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addButton.frame.origin.x, self.addButton.frame.origin.y, image.size.width / s, image.size.height / s)];
    self.videoImageView = imageView;
    imageView.image = image;
    [self addSubview:imageView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showVideo:)];
    [imageView addGestureRecognizer:tapGR];
    
    UIButton *delButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 20, 0, 20, 20)];
    [imageView addSubview:delButton];
    imageView.userInteractionEnabled = YES;
    [delButton addTarget:self action:@selector(deleteVideo:)];
    [delButton setImage:@"icon_delete"];
    
    if (self.imageFrameBlock) {
        self.imageFrameBlock(imageView.frame, firstImageData);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}


#pragma mark - 自定义方法
//- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
//
//    if (error) {
//        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
//    } else {
//        NSLog(@"视频保存成功");
//        _videoUrl = videoPath;
//        NSURL * url = [NSURL fileURLWithPath:videoPath];
//    }
//}



#pragma mark - 压缩视频
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
//                 UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 _outputURL = outputURL;
                 [self alertUploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
    
}


-(void)alertUploadVideo:(NSURL*)URL{
    CGFloat size = [self getFileSize:[URL path]];
    NSString *message;
    NSString *sizeString;
    CGFloat sizemb= size/1024;
    if(size<=1024){
        sizeString = [NSString stringWithFormat:@"%.2fKB",size];
    }else{
        sizeString = [NSString stringWithFormat:@"%.2fMB",sizemb];
    }
    
//    if(sizemb<2){
        [self uploadVideo:URL];
//    }
    
   /* else if(sizemb<=5){
        message = [NSString stringWithFormat:@"视频%@，大于2MB会有点慢，确定上传吗？", sizeString];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                                  message: message
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间（沙盒）
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self uploadVideo:URL];
            
        }]];
        [self.rootVC presentViewController:alertController animated:YES completion:nil];
        
        
    }*/
//    else if(sizemb>5){
//        message = [NSString stringWithFormat:@"视频%@，超过5MB，不能上传，抱歉。", sizeString];
//        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
//                                                                                  message: message
//                                                                           preferredStyle:UIAlertControllerStyleAlert];
//
//        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshwebpages" object:nil userInfo:nil];
//            [[NSFileManager defaultManager] removeItemAtPath:[URL path] error:nil];//取消之后就删除，以免占用手机硬盘空间
//
//        }]];
//        [self.rootVC presentViewController:alertController animated:YES completion:nil];
//    }
}

#pragma mark - 上传视频
-(void)uploadVideo:(NSURL*)URL{
    NSData *data = [NSData dataWithContentsOfURL:URL];
    if (self.videoDataBlock) {
        self.videoDataBlock(data);
    }

}

#pragma mark - 获取某一秒视频图片
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    if(!thumbnailImageRef){
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    }
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    return thumbnailImage;
}

#pragma mark -删除沙盒文件
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:_fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
        
    } else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
            
        } else {
            NSLog(@"dele fail");
            
        }
        
    }
    
}
    

@end
