//
//  YNSelfSizingBaseCollectionViewCell.h
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/29.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YNSelfSizingBaseCollectionViewCellType) {
    YNSelfSizingBaseCollectionViewCellTypeFixedWidthAndHeight,
    YNSelfSizingBaseCollectionViewCellTypeFixedWidth,
    YNSelfSizingBaseCollectionViewCellTypeFixedHeight
};

@interface YNSelfSizingBaseCollectionViewCell : UICollectionViewCell

-(YNSelfSizingBaseCollectionViewCellType) type;
-(CGFloat)fixedWidth;
-(CGFloat)fixedHeight;
-(UIView*)alignView;
-(CGFloat)alignOffset;

@end
