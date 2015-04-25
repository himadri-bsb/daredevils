//
//  RootViewController.m
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "ChatDataSource.h"
#import <SpeechKit/SpeechKit.h>
#import "CardIO.h"
#import "DetailsCardView.h"
#import "UIImageView+WebCache.h"
#import "CardCell.h"

@interface ChatViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate, SKVocalizerDelegate, CardIOPaymentViewControllerDelegate>

@property (strong, nonatomic) MJRefreshHeaderView *head;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) SKVocalizer *vocalizer;
@property (nonatomic, assign)ChatMode chatMode;

@end

@implementation ChatViewController{
    UUInputFunctionView *IFView;
}

- (instancetype)initWithMode:(ChatMode)chatMode {
    
    self = [super initWithNibName:@"ChatViewController" bundle:nil];
    if (self) {
        _chatMode = chatMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.chatMode) {
        case ChatModeBot:
            self.title = @"Mynt";
            break;
         case ChatModeOneToOne:
            self.title = @"Mynt Customre Care";
        default:
            break;
    }
    [self initBar];
    [self addRefreshViews];
    [self loadBaseViewsAndData];

    //TODO - Remove later
    [self performSelector:@selector(scanCreditCard) withObject:@"A Quick Brown fox jumped over a lazy dog." afterDelay:2.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initBar
{
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"Mynt",@"Mynt CS"]];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
}
- (void)segmentChanged:(UISegmentedControl *)segment
{
    [self.chatTableView reloadData];
}

- (void)addRefreshViews
{
//    __weak typeof(self) weakSelf = self;
//    
//    //load more
//    int pageNum = 3;
//    
//    _head = [MJRefreshHeaderView header];
//    _head.scrollView = self.chatTableView;
//    _head.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
//        
//        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
//        
//        if (weakSelf.chatModel.dataSource.count > pageNum) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.chatTableView reloadData];
//                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            });
//        }
//        [weakSelf.head endRefreshing];
//    };
}

- (void)loadBaseViewsAndData
{
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if ([[ChatDataSource sharedDataSource] dataArray].count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[ChatDataSource sharedDataSource] dataArray].count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": UIImageJPEGRepresentation(image, 1.0),
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [[ChatDataSource sharedDataSource] addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[ChatDataSource sharedDataSource] dataArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
//    if (cell == nil) {
//        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
//        cell.delegate = self;
//    }
//    
//    UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
//    UUMessage *message = [[UUMessage alloc] init];
//    [message setWithDict:[[ChatDataSource sharedDataSource] dataArray][indexPath.row]];
//    [messageFrame setMessage:message];
//    [cell setMessageFrame:messageFrame];
//    return cell;
    
    CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    if (cell == nil) {
        cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:@"http://myntra.myntassets.com/image/style/properties/142338/Kook-N-Keech-Disney-Men-Black-Mickey-T-shirt_1_473001cb64df1a49ef6e74fa969b2d3e.jpg"] placeholderImage:[UIImage imageNamed:@"placeholder-small"]];
    cell.sizeLabel.text = @"Size: 36";
    cell.priceLabel.text = @"Rs. 500";
    cell.nameLabel.text = @"HRX Men Indigo Blue Jeans";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
//    UUMessage *message = [[UUMessage alloc] init];
//    [message setWithDict:[[ChatDataSource sharedDataSource] dataArray][indexPath.row]];
//    [messageFrame setMessage:message];
//    return [messageFrame cellHeight];
    return 280.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Speech to Text
- (void)sayText:(NSString*)aText {
    self.vocalizer = [[SKVocalizer alloc] initWithLanguage:@"en_US" delegate:self];
    [self.vocalizer speakString:aText];
}

#pragma mark -
#pragma mark SKVocalizerDelegate methods

- (void)vocalizer:(SKVocalizer *)vocalizer willBeginSpeakingString:(NSString *)text {

}

- (void)vocalizer:(SKVocalizer *)vocalizer willSpeakTextAtCharacter:(NSUInteger)index ofString:(NSString *)text {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
}

- (void)vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    if (error !=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];        
        [alert show];
    }
}

#pragma mark - Credit card detection
- (void)scanCreditCard {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];


#if 1
    NSString *cardDetails = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
    NSLog(cardDetails);

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"CC Details" message:cardDetails delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
#endif

}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
