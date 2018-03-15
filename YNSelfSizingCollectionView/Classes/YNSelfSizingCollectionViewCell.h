//
//  YNSelfSizingCollectionViewCell.h
//
//  Created by wangya on 2018/1/29.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YNSelfSizingCollectionViewCellType) {
    YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight,
    YNSelfSizingCollectionViewCellTypeFixedWidth,
    YNSelfSizingCollectionViewCellTypeFixedHeight
};

@interface YNSelfSizingCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isTestCell;

-(YNSelfSizingCollectionViewCellType) type;
-(CGFloat)fixedWidth;
-(CGFloat)fixedHeight;
-(UIView*)alignView;
-(CGFloat)alignOffset;

@end
