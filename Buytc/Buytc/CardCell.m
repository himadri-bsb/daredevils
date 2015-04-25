//
//  CardCell.m
//  Buytc
//
//  Created by Mohan on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import "CardCell.h"

@interface CardCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIVisualEffectView *detailsBgView;

@end

@implementation CardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        [self setConstraints];
    }
    return self;
}

- (void)createSubViews {
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bgView.backgroundColor = [UIColor colorWithRed:62.0f/255.0f green:180.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    [self.contentView addSubview:self.bgView];
    
    self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.cardImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardImageView.contentMode = UIViewContentModeScaleToFill;
    [self.bgView addSubview:self.cardImageView];
    
    self.detailsBgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.detailsBgView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bgView addSubview:self.detailsBgView];
    
    self.sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.sizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sizeLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [self.detailsBgView addSubview:self.sizeLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.priceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [self.detailsBgView addSubview:self.priceLabel];
    
}

- (void)setConstraints {
    UIView *bgView = self.bgView;
    UIImageView *cardImageView = self.cardImageView;
    UIView *detailsBgView = self.detailsBgView;
    UILabel *sizeLabel = self.sizeLabel;
    UILabel *priceLabel = self.priceLabel;
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(bgView, cardImageView, detailsBgView,
                                                             sizeLabel, priceLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[bgView(==200)]"
                                                               options:0
                                                                metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[bgView(==240)]"
                                                                 options:0
                                                                 metrics:nil views:viewsDict]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cardImageView(==192)]"
                                                                            options:0
                                                                             metrics:nil views:viewsDict]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cardImageView(==232)]"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:cardImageView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:bgView
                                                       attribute:NSLayoutAttributeLeft multiplier:1.0f constant:4.0f]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:cardImageView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:bgView
                                                       attribute:NSLayoutAttributeTop multiplier:1.0f constant:4.0f]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(4)-[detailsBgView]-(4)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                        views:viewsDict]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detailsBgView(==30.0)]-(4)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                   views:viewsDict]];
    
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:sizeLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:detailsBgView
                                                             attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0f constant:6.0f]];
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:sizeLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:detailsBgView
                                                             attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f constant:0.0f]];
    
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:detailsBgView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0f constant:-6.0f]];
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:detailsBgView
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f constant:0.0f]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
