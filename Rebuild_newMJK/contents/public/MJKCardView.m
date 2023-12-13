//
//  MJKCardView.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCardView.h"
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>
#import "WXApi.h"


@implementation MJKCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NewUserSession instance].user.avatar]];
    self.nameLabel.text = [NewUserSession instance].user.nickName;
//    self.positionLabel.text = [NewUserSession instance].user.C_XCXPOSITION;
    self.phoneLabel.text = [NewUserSession instance].user.phonenumber;
    self.secondLabel.text = [NewUserSession instance].user.C_LOCNAME;
//    self.addressLabel.text = [NewUserSession instance].user.storeAddress;
    
   
}

- (void)setVcName:(NSString *)vcName {
    _vcName = vcName;
    if (![vcName isEqualToString:@"我的"]) {
        self.noticeLabel.text = @"长按小程序二维码发送给客户";
    }
    if ([vcName isEqualToString:@"我的"]) {
//        self.editButton.hidden = NO;
        self.editBGView.hidden = NO;
        self.editLabel.hidden = NO;
        self.headImageView.userInteractionEnabled = YES;
    } else {
//        self.editButton.hidden = YES;
        self.editBGView.hidden = YES;
        self.editLabel.hidden = YES;
        self.headImageView.userInteractionEnabled = NO;
    }
}

-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

- (IBAction)editButtonAction:(UIButton *)sender {
    if (self.editButtonActionBlock) {
        self.editButtonActionBlock([UIImage new]);
    }
}

-(void)uppicAction:(NSData *)data completeBlock:(void(^)(NSString *imageUrl))imageUrl{
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            NSString * imgUrl = [data objectForKey:@"url"];//回传
            if (imageUrl) {
                imageUrl(imgUrl);
            }
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}
- (IBAction)imageClickEditAction:(id)sender {
    if ([self.vcName isEqualToString:@"我的"]) {
        UIImage *image = [self makeImageWithView:self.thisCardView withSize:CGSizeMake(self.thisCardView.size.width, self.thisCardView.size.height)];
        if (self.editButtonActionBlock) {
            self.editButtonActionBlock(image);
        }
        return;
    }
    if (self.editButtonActionBlock) {
        self.editButtonActionBlock([UIImage new]);
    }
    
}
- (IBAction)showCardButtonAction:(id)sender {
    if (self.showButtonActionBlock) {
        self.showButtonActionBlock();
    }
}

- (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}
- (IBAction)shareWXButtonAction:(id)sender {
    [self shareMinWXWith:@"" withImgStr:self.qrCodeStr];
}

- (IBAction)longImageView:(UILongPressGestureRecognizer *)pressSender {
//    if (pressSender.state != UIGestureRecognizerStateBegan) {
//        return;
//    }
//    if ([self.vcName isEqualToString:@"我的"]) {
//        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//        launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
//        launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/homepage/homepage?usertoken=%@&accountid=%@&phone=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.phonenumber] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
//        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
//        [WXApi sendReq:launchMiniProgramReq];
//    } else {
//        [self shareMinWXWith:@"" withImgStr:self.qrCodeStr];
//    }
}

- (void)shareMinWXWith:(NSString *)sid withImgStr:(NSString *)imgStr{
//    UIImage *image=[self handleImageWithURLStr:imgStr];
    UIImage *image = [self makeImageWithView:self.thisCardView withSize:CGSizeMake(self.thisCardView.size.width, self.thisCardView.size.height)];
    
//    image = [self newSizeImage:CGSizeMake(300, 200) image:image];
    

    WXMiniProgramObject *miniProgramObj = [WXMiniProgramObject object];
    miniProgramObj.webpageUrl = @"http://www.qq.com"; // 兼容低版本的网页链接
    miniProgramObj.miniProgramType=WXMiniProgramTypeRelease;

    miniProgramObj.userName = [NewUserSession instance].C_GID;     // 小程序原始id
    miniProgramObj.path = [NSString stringWithFormat:@"/pages/homepage/homepage?usertoken=%@&accountid=%@&phone=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.phonenumber];            //小程序页面路径
    miniProgramObj.hdImageData= UIImageJPEGRepresentation(image, 0.1);
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = [NSString stringWithFormat:@"%@的名片",[NewUserSession instance].user.nickName];                    // 小程序消息title
//    msg.description = @"脉居客";// 小程序消息desc
    msg.thumbData = UIImageJPEGRepresentation(image, 0.1);// 小程序消息封面图片，小于128k
    msg.mediaObject=miniProgramObj;
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    
    req.message = msg;
    req.scene = WXSceneSession;  // 目前支持会话
    [WXApi sendReq:req completion:nil];
    
}

- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];
    
    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)closeView:(id)sender {
    [self removeFromSuperview];
}

- (void)setFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [super setFrame:frame];
}

@end
