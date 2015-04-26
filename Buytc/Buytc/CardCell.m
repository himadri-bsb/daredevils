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
    self.bgView.backgroundColor = NAV_BAR_COLOR;
    self.bgView.layer.cornerRadius = 10.0f;
    [self.contentView addSubview:self.bgView];
    
    self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.cardImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardImageView.contentMode = UIViewContentModeScaleToFill;
    self.cardImageView.layer.cornerRadius = 8.0f;
    self.cardImageView.clipsToBounds = YES;
    [self.bgView addSubview:self.cardImageView];
    
    self.detailsBgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.detailsBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailsBgView.layer.cornerRadius = 8.0f;
    self.detailsBgView.clipsToBounds = YES;
    [self.bgView addSubview:self.detailsBgView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
    self.nameLabel.numberOfLines = 2;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.detailsBgView addSubview:self.nameLabel];
    
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
    UILabel *nameLabel = self.nameLabel;
    UILabel *sizeLabel = self.sizeLabel;
    UILabel *priceLabel = self.priceLabel;
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(bgView, cardImageView, detailsBgView,
                                                             sizeLabel, priceLabel, nameLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[bgView(==200)]"
                                                               options:0
                                                                metrics:nil views:viewsDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[bgView(==240)]"
                                                                 options:0
                                                                 metrics:nil views:viewsDict]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cardImageView(==198)]"
                                                                            options:0
                                                                             metrics:nil views:viewsDict]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cardImageView(==238)]"
                                                                             options:0
                                                                             metrics:nil views:viewsDict]];
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:cardImageView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:bgView
                                                       attribute:NSLayoutAttributeLeft multiplier:1.0f constant:1.0f]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:cardImageView
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:bgView
                                                       attribute:NSLayoutAttributeTop multiplier:1.0f constant:1.0f]];
    
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(1)-[detailsBgView]-(1)-|"
                                                                     options:0
                                                                     metrics:nil
                                                                        views:viewsDict]];
    [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[detailsBgView(==60.0)]-(1)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                   views:viewsDict]];
    
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:detailsBgView
                                                             attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0f constant:6.0f]];
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:detailsBgView
                                                             attribute:NSLayoutAttributeTop
                                                             multiplier:1.0f constant:1.0f]];
    [detailsBgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameLabel(<=180@751)]"
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
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nameLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f constant:1.0f]];
    
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:detailsBgView
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0f constant:-6.0f]];
    [detailsBgView addConstraint:[NSLayoutConstraint constraintWithItem:priceLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:sizeLabel
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f constant:0.0f]];
}

@end
