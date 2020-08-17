//
//  AsyncImageView.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncImageView : UIView

@property (strong, nonatomic) UIImage * image;
@property (nonatomic) BOOL isLoading;

- (void)willStartLoadingImage;
- (void)hasErrorWhileLoadingImage;
- (void)didFinishLoadingImageWith:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
