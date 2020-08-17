//
//  AsyncImageView.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "AsyncImageView.h"

@interface AsyncImageView ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIActivityIndicatorView * progressView;
@property (nonatomic) BOOL showBorders;

@end

@implementation AsyncImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.cornerRadius = 15.0f;
        self.imageView.userInteractionEnabled = NO;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.125] CGColor];
        if (@available(iOS 13.0, *)) {
            self.imageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        } else {
            self.imageView.backgroundColor = [UIColor colorWithRed:247 green:246 blue:246 alpha:1.0];
        }
        self.progressView = [UIActivityIndicatorView new];
        self.isLoading = NO;
        [self.progressView startAnimating];
        [self addSubview:self.imageView];
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.progressView.center = self.imageView.center;
}

- (void)setShowBorders:(BOOL)showBorders {
    if (showBorders) {
        self.imageView.layer.borderWidth = 1.0;
    } else {
        self.imageView.layer.borderWidth = 0.0;
    }
}

- (void)didFinishLoadingImageWith:(UIImage *)image {
    self.image = image;
    self.isLoading = NO;
    [self.progressView stopAnimating];
}

- (void)willStartLoadingImage {
    self.isLoading = YES;
    self.imageView.image = nil;
    [self.progressView startAnimating];
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)hasErrorWhileLoadingImage {
}

@end
