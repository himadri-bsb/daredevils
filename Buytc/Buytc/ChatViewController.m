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
#import "AFNetworking.h"
#import "CardModel.h"
#import "StateMachineManager.h"
#import "UUImageAvatarBrowser.h"

@interface ChatViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate, SKVocalizerDelegate, CardIOPaymentViewControllerDelegate,DetailsCardViewDelegate>

@property (strong, nonatomic) MJRefreshHeaderView *head;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) SKVocalizer *vocalizer;
@property (nonatomic, assign)ChatMode chatMode;
@property (nonatomic, copy) NSString *textToPlay;

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
    [[StateMachineManager sharedInstance] setChatDelegate:self];

    //TODO - Remove later
    //[self performSelector:@selector(displayText:) withObject:@"Jatin, Mohan, Himadri, Vijay" afterDelay:2.0];
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
   // UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"Mynt",@"Mynt CS"]];
    //[segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    //segment.selectedSegmentIndex = 0;
    //self.navigationItem.titleView = segment;
    self.title = @"Mynt Chat";
    self.navigationController.navigationBar.tintColor = NAV_BAR_COLOR;
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


- (void)sendBotTextMessage:(NSString*)aText {
    NSDictionary *dic = @{@"strContent":aText,
                          @"type": @(UUMessageTypeText),
                          @"from":@(UUMessageFromOther)
                          };
    [self dealTheFunctionData:dic];
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
    
    NSDictionary *messageDict = [[ChatDataSource sharedDataSource] dataArray][indexPath.row];
    if ([messageDict valueForKey:@"type"] && [[messageDict valueForKey:@"type"] integerValue] == UUMessageTypeCard) {
        CardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];
        if (cell == nil) {
            cell = [[CardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:[messageDict objectForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"placeholder-small"]];
        cell.sizeLabel.text = [messageDict objectForKey:@"size"];
        cell.priceLabel.text = [NSString stringWithFormat:@"Rs.%@",[[messageDict objectForKey:@"price"] stringValue]];
        cell.nameLabel.text = [messageDict objectForKey:@"brandName"];
        return cell;
    } else {
        UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        if (cell == nil) {
            cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
            cell.delegate = self;
        }
        
        UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:[[ChatDataSource sharedDataSource] dataArray][indexPath.row]];
        [messageFrame setMessage:message];
        [cell setMessageFrame:messageFrame];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *messageDict = [[ChatDataSource sharedDataSource] dataArray][indexPath.row];
    if ([messageDict valueForKey:@"type"] && [[messageDict valueForKey:@"type"] integerValue] == UUMessageTypeCard) {
        return 280.0f;
    } else {
        UUMessage *message = [[UUMessage alloc] init];
        UUMessageFrame * messageFrame = [[UUMessageFrame alloc] init];
        [message setWithDict:messageDict];
        [messageFrame setMessage:message];
        return [messageFrame cellHeight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CardCell class]]) {
        CardCell *card = (CardCell *)cell;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *messageDict = [[ChatDataSource sharedDataSource] dataArray][indexPath.row];
            UIImageView* orginImageView = card.cardImageView;
            CGRect oldframe=[orginImageView convertRect:orginImageView.bounds toView:self.navigationController.view];
            DetailsCardView *detailView = [[DetailsCardView alloc] initWithFrame:oldframe];
            detailView.imageView.image = card.cardImageView.image;
            if (messageDict[@"brandName"]) {
                detailView.productNameLabel.text = messageDict[@"brandName"];
            }
            if (messageDict[@"size"]) {
                detailView.sizeLabel.text = [NSString stringWithFormat:@"Sizes: %@", messageDict[@"size"]];
            }
            
            if (messageDict[@"discount"]) {
                detailView.discountLabel.text = messageDict[@"discount"];
            }
            
            if (messageDict[@"price"]) {
                detailView.sizeLabel.text = [NSString stringWithFormat:@"Price: %@", messageDict[@"price"]];
            }
            
            
            [self.navigationController.view addSubview:detailView];
            [detailView setDelegate:self];
            [UIView animateWithDuration:0.3 animations:^{
                detailView.frame = self.view.bounds;
            } completion:^(BOOL finished) {
                
            }];
            
        });
    }
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

    if([self.textToPlay length]) {
        [self sendBotTextMessage:self.textToPlay];
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

#pragma mark - Network
- (void)loadHttpRequest:(NSURLRequest*)aRequest {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:aRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Sucess
        NSArray *results = responseObject[@"data"][@"results"][@"products"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index < 5; index++) {
            NSDictionary *dict = results[index];

            CardModel *model = [[CardModel alloc] init];
            model.itemBrandName = dict[@"product"];
            model.imageUrl = dict[@"search_image"];
            model.price = dict[@"price"];
            model.size = dict[@"sizes"];
            model.disCount = dict[@"dre_discount_label"];
            [array addObject:model];
            
            [[ChatDataSource sharedDataSource] addCard:model];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatTableView reloadData];
            [self tableViewScrollToBottom];
        });
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Http"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];

    [operation start];
}

- (void) loadDummyHttp {
    [self makeHttpCallWithBaseAPI:@"men-casual-shirts" parameterDictionary:@{@"discounted_price":@"849,849",
                                                                             @"colour_family_list":@"blue"}];

}

#pragma mark - State Machine Manager Delegate
- (void)displayText:(NSString *)textToDisplay {
    self.textToPlay = textToDisplay;
    [self sayText:self.textToPlay];
}

/** Example for complete API:
 http://developer.myntra.com/search/data/men-casual-shirts?f=discounted_price%3A849%2C849%3A%3Acolour_family_list%3Ablue&p=1&userQuery=false
 **/
- (void)makeHttpCallWithBaseAPI:(NSString *)baseAPI parameterDictionary:(NSDictionary *)parameterDictionary {
    NSString *filter = nil;
    NSSet *supportedFilters = [NSSet setWithArray:@[kBrand,kColour,kPrice,kSize]];
    if([parameterDictionary count]) {
        for(NSString *key in [parameterDictionary allKeys]) {
            if([supportedFilters containsObject:key]) {
                if(!filter) {
                    filter = [NSString stringWithFormat:@"f=%@:%@:",key,parameterDictionary[key]];
                }
                else {
                    filter = [filter stringByAppendingString:[NSString stringWithFormat:@":%@:%@:",key,parameterDictionary[key]]];
                }
            }
        }
    }

    NSString *newFilter = nil;
    if([filter length]) {
        newFilter = [filter substringToIndex:[filter length]-1];
        newFilter = [self urlEncodeString:newFilter];
    }

    NSString *finalUrl = nil;
    if(newFilter) {
        finalUrl = [NSString stringWithFormat:@"http://developer.myntra.com/search/data/%@?%@%@",baseAPI,newFilter,@"&p=1&userQuery=false"];
    }
    else {
        finalUrl = [NSString stringWithFormat:@"http://developer.myntra.com/search/data/%@?%@",baseAPI,@"&p=1&userQuery=false"];
    }

    
    
    NSURL *url = [NSURL URLWithString:finalUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self loadHttpRequest:request];
}

- (NSString *)urlEncodeString:(NSString *)str {
    NSString* escaped_value = (__bridge_transfer NSString * ) CFURLCreateStringByAddingPercentEscapes(
                                                                                                      NULL, /* allocator */
                                                                                                      (CFStringRef)str,
                                                                                                      NULL, /* charactersToLeaveUnescaped */
                                                                                                      (CFStringRef)@":,",
                                                                                                      kCFStringEncodingUTF8);
    return escaped_value;
}

- (void)didTapCancel:(id)sender {
    [sender removeFromSuperview];
}

- (void)didTapLike:(id)sender {
    
}
- (void)didTapDisLike:(id)sender {
    
}

- (void)didTapBuy:(id)sender {
    
}

@end
