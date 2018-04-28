//
//  YNSelfSizingCollectionViewCell.h
//
//  Created by wangya on 2018/1/29.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNSelfSizingCollectionView;
typedef NS_ENUM(NSUInteger, YNSelfSizingCollectionViewCellLayoutType) {
    YNSelfSizingCollectionViewCellLayoutTypeFrameLayout,
    YNSelfSizingCollectionViewCellLayoutTypeAutoLayout
};
typedef NS_ENUM(NSUInteger, YNSelfSizingCollectionViewCellType) {
    YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight,
    YNSelfSizingCollectionViewCellTypeFixedWidth,
    YNSelfSizingCollectionViewCellTypeFixedHeight
};

@interface YNSelfSizingCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) YNSelfSizingCollectionView *collectionView;
@property (nonatomic, assign) BOOL isTestCell;

-(YNSelfSizingCollectionViewCellLayoutType)layoutType;
-(YNSelfSizingCollectionViewCellType)selfSizingType;
-(CGFloat)fixedWidth;
-(CGFloat)fixedHeight;
-(UIView*)alignView;
-(CGFloat)alignOffset;

// must use contentView's method
- (void)addSubview:(UIView *)view NS_UNAVAILABLE;
@end
