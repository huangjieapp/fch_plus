//
//  MJKTestViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKUploadFileViewController.h"
#import "MJKChooseUpFileViewController.h"
#import "DBNavigationController.h"

@interface MJKUploadFileViewController ()
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** 选择文件路径button*/
@property (nonatomic, strong) UIButton *chooseFileButton;
/** <#注释#>*/
@property (nonatomic, strong) NSString *fileName;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isNoSpecification;
@end

@implementation MJKUploadFileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(folderName:) name:@"fileName" object:nil];
    
}

- (void)folderName:(NSNotification *)notifcation {
    NSDictionary *dic = notifcation.userInfo;
    [self.chooseFileButton setTitleNormal:dic[@"folderName"]];
    self.fileName = dic[@"fileID"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:@"fileName"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 60, 20, 50, 30)];
    [button setTitleNormal:@"取消"];
    [button setTitleColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(dismissVC)];
    [self.view addSubview:button];
    
    [self.view addSubview:self.bottomView];
    
    [self configFileTypeView];
}

- (void)configFileTypeView {
    NSString *path = self.fileDic[@"filePath"];
    NSString * sampleFile= [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FileType.plist"];
    NSDictionary*  dic_sections = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSString *imageStr = @"疑问文件";
    self.isNoSpecification = YES;
    NSArray *keyArray = dic_sections.allKeys;
    for (int i = 0; i < keyArray.count; i++) {
        NSString *key = keyArray[i];
        if (([path hasSuffix:key.lowercaseString] || [path hasSuffix:key.uppercaseString])) {
            imageStr = dic_sections[key];
            self.isNoSpecification = NO;
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMidY(self.view.frame) - 100, 100, 100)];
    imageView.image = [UIImage imageNamed:imageStr];
    [self.view addSubview:imageView];
    
    UILabel *sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.bottomView.frame) - 80, KScreenWidth, 30)];
    sizeLabel.textColor = [UIColor grayColor];
    sizeLabel.font = [UIFont systemFontOfSize:14.f];
    sizeLabel.textAlignment = NSTextAlignmentCenter;
    NSString *sizeStr = [self fileSizeAtPath];
    if (self.fileDic != nil) {
        sizeLabel.text = sizeStr;
    }
    [self.view addSubview:sizeLabel];
    
    UILabel *fileNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(sizeLabel.frame) - 30, KScreenWidth, 30)];
    fileNameLabel.textColor = [UIColor blackColor];
    fileNameLabel.font = [UIFont systemFontOfSize:16.f];
    fileNameLabel.textAlignment = NSTextAlignmentCenter;
    if (self.fileDic != nil) {
        fileNameLabel.text = self.fileDic[@"fileName"];
    }
    [self.view addSubview:fileNameLabel];
}
//单个文件的大小
- (NSString *)fileSizeAtPath{
    
    NSData *data = [NSData dataWithContentsOfFile:self.fileDic[@"filePath"]];
    CGFloat size = data.length;
    if ((size / 1024) > 1024) {
        size = size / 1024 / 1024;
//        if (size / 1024 > 1024) {
//            size = size / 1024;
            return [NSString stringWithFormat:@"%.0fM",size];
//        } else {
//            size = size / 1024;
//            return [NSString stringWithFormat:@"%.0fM",size];
//        }
    } else {
        size = size / 1024;
        return [NSString stringWithFormat:@"%.0fk",size];
    }
    return [NSString stringWithFormat:@"%fbyte",size];

}

#pragma mark - click button
- (void)chooseFileButtonAction:(UIButton *)sender {
    if (self.isNoSpecification == YES) {
        [JRToast showWithText:@"未识别到此文件类型"];
        return;
    }
//    MJKShareFolderViewController *vc = [[MJKShareFolderViewController alloc]init];
//    vc.isHaveBack = YES;
//    vc.fileExtension = [self.fileDic[@"fileName"] pathExtension];
////    [self.navigationController pushViewController:vc animated:YES];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    DBNavigationController *navigationController = [[DBNavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:navigationController animated:YES completion:nil];
    
    MJKChooseUpFileViewController *vc = [[MJKChooseUpFileViewController alloc]init];
    NSString *path = self.fileDic[@"filePath"];
    NSString * sampleFile= [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FileType.plist"];
    NSDictionary*  dic_sections = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    NSArray *keyArray = dic_sections.allKeys;
    for (int i = 0; i < keyArray.count; i++) {
        NSString *key = keyArray[i];
        if (([path hasSuffix:key.lowercaseString] || [path hasSuffix:key.uppercaseString])) {
            vc.fileExtension = dic_sections[key];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)uploadButtonAction:(UIButton *)sender {
    DBSelf(weakSelf);
    if (self.fileName.length <= 0) {
        [JRToast showWithText:@"请选择上传路径"];
        return;
    }
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.fileDic[@"filePath"]]];
    NSData *data = [NSData dataWithContentsOfFile:self.fileDic[@"filePath"]];
    NSString *mimeType = [self.fileDic[@"fileName"] pathExtension];
//    NSString *fileNameStr = [NSString utf8ToUnicode:self.fileDic[@"fileName"]];
    NSString *fileNameStr = [self.fileDic[@"fileName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"formal"] isEqualToString:@"YES"] ? [NSString stringWithFormat:@"%@/%@/%@/%@/uploadFileQINIUByGXWJ.bk?",[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"],[NewUserSession instance].user.u051Id, self.fileName,fileNameStr] : [NSString stringWithFormat:@"%@/%@/%@/%@/uploadFileQINIUByGXWJ.bk?",[[NSUserDefaults standardUserDefaults]objectForKey:@"ip"],[NewUserSession instance].user.u051Id, self.fileName,fileNameStr];
//    NSString *urlStr = [[[NSUserDefaults standardUserDefaults]objectForKey:@"formal"] isEqualToString:@"YES"] ?  [NSString stringWithFormat:@"http://121.40.174.159:8585/MJK2.0/mobile_user/%@/%@/uploadFileQINIUByGXWJ.bk?",[NewUserSession instance].user.u051Id, self.fileName] : [NSString stringWithFormat:@"http://121.41.13.95:8080/MJK2.0/mobile_user/%@/%@/uploadFileQINIUByGXWJ.bk?",[NewUserSession instance].user.u051Id, self.fileName];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataFileWithUrl:urlStr parameters:nil file:data andFileName:self.fileDic[@"fileName"] andMimeType:mimeType compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            NSError *error = nil;
            [[NSFileManager defaultManager]removeItemAtPath:self.fileDic[@"filePath"] error:&error];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
#pragma mark dismiss vc
- (void)dismissVC {
    
    NSError *error = nil;
    [[NSFileManager defaultManager]removeItemAtPath:self.fileDic[@"filePath"] error:&error];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-80 - SafeAreaBottomHeight, KScreenWidth, 80)];
        _bottomView.backgroundColor = [UIColor blackColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"选择上传路径:";
        titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_bottomView addSubview:titleLabel];
        
        UIButton *chooseFileButton = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), KScreenWidth - 20 - 100, 45)];
        self.chooseFileButton = chooseFileButton;
        [chooseFileButton setTitleNormal:@"请选择上传路径"];
        [chooseFileButton setImage:@"上传文件夹"];
        [chooseFileButton setBackgroundColor:kBackgroundColor];
        [chooseFileButton setTitleColor:[UIColor blackColor]];
        chooseFileButton.layer.cornerRadius = 5.f;
        [chooseFileButton addTarget:self action:@selector(chooseFileButtonAction:)];
        [_bottomView addSubview:chooseFileButton];
        
        UIButton *uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(chooseFileButton.frame) + 5, CGRectGetMinY(chooseFileButton.frame), 95, 45)];
        [uploadButton setBackgroundColor:KNaviColor];
        [uploadButton setTitleColor:[UIColor blackColor]];
        [uploadButton setTitleNormal:@"上传"];
        uploadButton.layer.cornerRadius = 5.f;
        [uploadButton addTarget:self action:@selector(uploadButtonAction:)];
        [_bottomView addSubview:uploadButton];
    }
    return _bottomView;
}


@end
