//
//  MJKMessageEditRecordCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMessageEditRecordCell.h"

 #import <AVFoundation/AVFoundation.h>

@interface MJKMessageEditRecordCell ()
/** AVAudioRecorder*/
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@end

@implementation MJKMessageEditRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self record];
}
- (IBAction)longButtonAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.audioRecorder record];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.audioRecorder stop];
    }
}

- (void)record {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"text.caf"];
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
    dic[AVSampleRateKey] = @11025;
    dic[AVNumberOfChannelsKey] = @1;
    dic[AVLinearPCMBitDepthKey] = @8;
    dic[AVEncoderAudioQualityKey] = @(AVAudioQualityMax);
    dic[AVEncoderBitRateKey] = @8000;
    
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:dic error:&error];
    NSLog(@"error ------- %@",error);
    [self.audioRecorder prepareToRecord];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKMessageEditRecordCell";
    MJKMessageEditRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
