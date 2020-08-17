//
//  AsyncImageViewCell.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "AsyncImageViewCell.h"
#import "AsyncImageView.h"

@interface AsyncImageViewCell ()
    @property (nonatomic, strong) AsyncImageView * asyncImageView;
@end

@implementation AsyncImageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.asyncImageView = [AsyncImageView new];
        [self.contentView addSubview:self.asyncImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.bounds = CGRectInset(self.contentView.frame, 10.0f, 0.0f);
    self.asyncImageView.frame = self.contentView.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.image = nil;
}

- (void)willStartLoadingImage {
    [self.asyncImageView willStartLoadingImage];
}

- (void)setImage:(UIImage *)image {
    self.asyncImageView.image = image;
}

- (void)hasErrorWhileLoadingImage {
    [self.asyncImageView hasErrorWhileLoadingImage];
}

- (void)didFinishLoadingImageWith:(UIImage *)image {
    [self.asyncImageView didFinishLoadingImageWith:image];
}

@end
