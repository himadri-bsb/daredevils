//
//  DetailsCardView.h
//  Buytc
//
//  Created by Mohan on 25/04/15.
//  Copyright (c) 2015 Himadri. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailsCardViewDelegate <NSObject>

- (void)didTapLike:(id)sender;
- (void)didTapDisLike:(id)sender;
- (void)didTapCancel:(id)sender;
- (void)didTapBuy:(id)sender;

@end

@interface DetailsCardView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *discountLabel;

@property (nonatomic, weak) id <DetailsCardViewDelegate> delegate;

@end
