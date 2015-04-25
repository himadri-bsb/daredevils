//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//



#import "UUInputFunctionView.h"
#import "UUProgressHUD.h"
#import <SpeechKit/SpeechKit.h>
#import "UUMessageFrame.h"
#import "UUProgressHUD.h"

@interface UUInputFunctionView ()<UITextViewDelegate, SKRecognizerDelegate>
{
    BOOL isbeginVoiceRecord;

    UILabel *placeHold;
}

@property (nonatomic, strong) SKRecognizer *voiceRecognizer;
@end

@implementation UUInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-40, Main_Screen_Width, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
       // MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-50, 5, 40, 30);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"Send" forState:UIControlStateNormal];
//        [self.btnSendMessage setBackgroundImage:[[UIImage imageNamed:@"Chat_take_picture"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.btnSendMessage setTitleColor:NAV_BAR_COLOR forState:UIControlStateNormal];
        //self.btnSendMessage.tintColor = NAV_BAR_COLOR;
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setImage:[[UIImage imageNamed:@"chat_voice_record"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.btnVoiceRecord.tintColor = NAV_BAR_COLOR;
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];

        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(70, 5, Main_Screen_Width-70*2, 30);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[[UIImage imageNamed:@"chat_message_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.btnVoiceRecord.tintColor = NAV_BAR_COLOR;
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45-10, 30)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = NAV_BAR_COLOR.CGColor;
        self.TextViewInput.font = ChatContentFont;
        [self addSubview:self.TextViewInput];
        
        //输入框的提示语
        placeHold = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
        [placeHold setFont:ChatContentFont];
        placeHold.text = @"Talk To Me For Buying";
        placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.TextViewInput addSubview:placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    SKEndOfSpeechDetection detectionType = SKShortEndOfSpeechDetection;
    NSString* recoType = SKDictationRecognizerType;
    NSString* langType = @"en_US";
    self.voiceRecognizer = [[SKRecognizer alloc] initWithType:recoType
                                                    detection:detectionType
                                                     language:langType
                                                     delegate:self];
}

- (void)endRecordVoice:(UIButton *)button
{

}

- (void)cancelRecordVoice:(UIButton *)button
{
    
}


#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer {
    NSLog(@"Speechkit Recording started.");
    
    [UUProgressHUD changeSubTitle:@"Recording..."];
    [UUProgressHUD show];

    [self.btnVoiceRecord setTitle:@"Recording..." forState:UIControlStateNormal];

}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    [UUProgressHUD changeSubTitle:@"Processing..."];
    NSLog(@"Speechkit Recording finished.");
    [self.btnVoiceRecord setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Speechkit Got results.");
    NSLog(@"Speechkit Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id

    long numOfResults = [results.results count];

    if (numOfResults > 0) {
        [self.delegate UUInputFunctionView:self sendMessage:[results firstResult]];
    }

    if (numOfResults > 1) {
        //If needed do something with the alternative text
    }

    if (results.suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [UUProgressHUD dismissWithSuccess:@""];
    [self toggleRecording];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    [UUProgressHUD dismissWithSuccess:@""];
    [self toggleRecording];
    
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id


    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }

}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
}




#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
    //[self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1];
    [UUProgressHUD dismissWithSuccess:@"Success"];
   
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)failRecord
{
    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    [self toggleRecording];
    [self beginRecordVoice:nil];
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage) {
        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputFunctionView:self sendMessage:resultStr];
    }
    else{
        [self.TextViewInput resignFirstResponder];
        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images",nil];
        [actionSheet showInView:self.window];
    }
}

- (void)toggleRecording {
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [self.TextViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
    }

}

#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    placeHold.hidden = textView.text.length>0;
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = !isPhoto;
    //UIImage *buttonimage = [UIImage imageNamed:@"sendicon_2x"];
    [self.btnSendMessage setTitle:@"Send" forState:UIControlStateNormal];
//    self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
//    UIImage *image = [[UIImage imageNamed:isPhoto?@"Chat_take_picture":@"chat_send_message"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
}


#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate UUInputFunctionView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
