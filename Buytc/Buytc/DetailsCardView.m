//
//  DetailsCardView.m
//  Buytc
//
//  Created by Mohan on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "DetailsCardView.h"

#define IMAGE_SIZE_WIDTH 140.0f

#define BG_VIEW_TOP_PADING 100.0f
#define BG_VIEW_HORIZONTAL_PADING 20.0f
#define BG_VIEW_BOTTOM_PADDING 100.0f

@interface DetailsCardView()

@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *dislikeButton;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation DetailsCardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        [self addConstraintLayouts];
    }
    return self;
}

#pragma mark - UI Creation

- (void)createSubViews {
    
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.visualEffectView];
    
    self.cardView = [[UIView alloc] initWithFrame:CGRectZero];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.layer.cornerRadius = 6.0f;
    self.cardView.backgroundColor = [UIColor whiteColor];
    [self.visualEffectView addSubview:self.cardView];
    
    self.imageView =[[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.cardView addSubview:self.imageView];
    
    self.productNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.productNameLabel.numberOfLines = 2;
    [self.productNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    [self.cardView addSubview:self.productNameLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.priceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0f]];
    self.priceLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:51.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [self.cardView addSubview:self.priceLabel];
    
    self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.sizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sizeLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    self.sizeLabel.textColor = [UIColor colorWithRed:136.0f/255.0f green:144.0f/255.0f blue:132.0f/255.0f alpha:1.0];
    [self.cardView addSubview:self.sizeLabel];
    
    self.discountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.discountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.discountLabel setFont:[UIFont systemFontOfSize:12.0f]];
    self.discountLabel.textColor = [UIColor redColor];
    [self.discountLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f]];
    [self.cardView addSubview:self.discountLabel];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateHighlighted];
    [self.likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.likeButton];
    
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dislikeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dislikeButton setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    [self.dislikeButton setImage:[UIImage imageNamed:@"dislike_selected"] forState:UIControlStateHighlighted];
    [self.dislikeButton addTarget:self action:@selector(disLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.dislikeButton];
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.buyButton setBackgroundColor:[UIColor whiteColor]];
    self.buyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.buyButton setTitle:@"Buy now" forState:UIControlStateNormal];
    [self.buyButton setTitleColor:NAV_BAR_COLOR
                         forState:UIControlStateNormal];
    [self.buyButton setTitleColor:NAV_BAR_COLOR
                         forState:UIControlStateHighlighted];
    self.buyButton.layer.cornerRadius = 10.0f;
    self.buyButton.layer.borderWidth = 1.0f;
    [self.buyButton addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyButton setBackgroundColor:NAV_BAR_COLOR];
    [self.buyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 100)];
    self.buyButton.layer.cornerRadius = 10;
    [self.visualEffectView addSubview:self.buyButton];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualEffectView addSubview:self.cancelButton];
}

- (void)addConstraintLayouts {
    
    UIView *effectView = self.visualEffectView;
    UIView *cardView = self.cardView;
    UIView *imageview = self.imageView;
    UIView *productLabel = self.productNameLabel;
    UILabel *sizeLabel = self.sizeLabel;
    UILabel *priceLabel = self.priceLabel;
    UILabel *discountLabel = self.discountLabel;
    UIButton *likeButton = self.likeButton;
    UIButton *dislikeButton = self.dislikeButton;
    UIButton *buyButton = self.buyButton;
    UIButton *cancelButton = self.cancelButton;
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(cardView, imageview,
                                                             productLabel, priceLabel,
                                                             sizeLabel, discountLabel,
                                                             likeButton, dislikeButton,
                                                             effectView, buyButton,
                                                             cancelButton);
    
    NSDictionary *metrics = @{@"cardViewTopPading":@(BG_VIEW_TOP_PADING),
                              @"cardViewBottomPadding":@(BG_VIEW_BOTTOM_PADDING),
                              @"cardViewHorizontalPadding":@(BG_VIEW_HORIZONTAL_PADING)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[effectView]|"
                                                                options:0
                                                                 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[effectView]|"
                                                                 options:0
                                                                 metrics:nil views:viewsDict]];
    
    [effectView addConstraint:[NSLayoutConstraint constraintWithItem:buyButton
                                                    attribute:NSLayoutAttributeCenterX
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:effectView
                                                    attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f constant:0.0f]];
    [effectView addConstraint:[NSLayoutConstraint constraintWithItem:buyButton
                                                    attribute:NSLayoutAttributeBottom
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:effectView
                                                    attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f constant:-35.0f]];
    [effectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[buyButton(==89.0)]"
                                                                      options:0
                                                                       metrics:metrics views:viewsDict]];
    [effectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[buyButton(==35.0)]"
                                                                       options:0
                                                                       metrics:metrics views:viewsDict]];
    
    [effectView addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:effectView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0f constant:20.0f]];
    [effectView addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:effectView
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0f constant:-10.0f]];
    [effectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancelButton(==60.0)]"
                                                                       options:0
                                                                       metrics:metrics views:viewsDict]];
    [effectView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(==40.0)]"
                                                                       options:0
                                                                       metrics:metrics views:viewsDict]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(cardViewHorizontalPadding)-[cardView]-(cardViewHorizontalPadding)-|"
                                                                options:0
                                                                 metrics:metrics views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(cardViewTopPading)-[cardView]-(cardViewBottomPadding)-|"
                                                                options:0
                                                                 metrics:metrics views:viewsDict]];
    
    [cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageview]|"
                                                                    options:0
                                                                    metrics:metrics
                                                                       views:viewsDict]];
    [cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(6.0)-[imageview(<=250@751)]"
                                                                    options:0
                                                                    metrics:metrics
                                                                       views:viewsDict]];
    
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:discountLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:imageview
                                                        attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f constant:10.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:discountLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:imageview
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f constant:-10.0f]];
    
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:productLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:imageview
                                                        attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:10.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:productLabel
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:cardView
                                                        attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f constant:10.0f]];
    
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:sizeLabel
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:productLabel
                                                        attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:4.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:sizeLabel
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:productLabel
                                                        attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f constant:0.0f]];
    
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:sizeLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:4.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:productLabel
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f constant:0.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:productLabel
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:cardView
                                                        attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0f constant:-2*BG_VIEW_HORIZONTAL_PADING]];
    
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:likeButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:cardView
                                                        attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f constant:-10.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:likeButton
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:cardView
                                                        attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:-10.0f]];
    
    [cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[likeButton(==30.0)]"
                                                                    options:0
                                                                    metrics:metrics views:viewsDict]];
    [cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[likeButton(==30.0)]"
                                                                     options:0
                                                                     metrics:metrics views:viewsDict]];
    
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:dislikeButton
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:likeButton
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f constant:-6.0f]];
    [cardView addConstraint:[NSLayoutConstraint constraintWithItem:dislikeButton
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cardView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:-10.0f]];
    [cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dislikeButton(==30.0)]"
                                                                     options:0
                                                                     metrics:metrics views:viewsDict]];
    [cardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dislikeButton(==30.0)]"
                                                                     options:0
                                                                     metrics:metrics views:viewsDict]];
}

#pragma mark - button actions

- (void)likeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapLike:)]) {
        [self.delegate didTapLike:self];
    }
}

- (void)disLikeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapDisLike:)]) {
        [self.delegate didTapDisLike:self];
    }
}

- (void)buyAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapBuy:)]) {
        [self.delegate didTapBuy:self];
    }
}

- (void)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTapCancel:)]) {
        [self.delegate didTapCancel:self];
    }
}


@end
