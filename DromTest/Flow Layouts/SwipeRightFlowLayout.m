//
//  SwipeRightFlowLayout.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "SwipeRightFlowLayout.h"

@implementation SwipeRightFlowLayout

//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes * attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
//    CGFloat endx = CGRectGetWidth(self.collectionView.frame);
//    CATransform3D endTransform = CATransform3DMakeTranslation(endx, 0, 0);
//    attributes.alpha = 0.0f;
//    attributes.transform3D = endTransform;
//    return attributes;
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}

- (CGFloat)minimumLineSpacing {
    return 10.0f;
}

@end

