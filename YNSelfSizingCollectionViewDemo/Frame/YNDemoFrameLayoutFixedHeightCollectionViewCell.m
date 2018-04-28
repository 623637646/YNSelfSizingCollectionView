//
//  YNDemoFrameLayoutFixedHeightCollectionViewCell.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/4/28.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoFrameLayoutFixedHeightCollectionViewCell.h"
#import "YNSelfSizingCollectionView.h"

@interface YNDemoFrameLayoutFixedHeightCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoFrameLayoutFixedHeightCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, CGFLOAT_MAX, 0);
    [self.label sizeToFit];
    self.label.frame = CGRectMake(20, (self.bounds.size.height - self.label.frame.size.height) / 2.f, self.label.frame.size.width, self.label.frame.size.height);
    
}

-(void)setTitle:(NSString *)title{
    self.label.text = title;
    [self setNeedsLayout];
}

-(YNSelfSizingCollectionViewCellLayoutType)layoutType{
    return YNSelfSizingCollectionViewCellLayoutTypeFrameLayout;
}

-(YNSelfSizingCollectionViewCellType)selfSizingType{
    return YNSelfSizingCollectionViewCellTypeFixedHeight;
}

-(CGFloat)fixedHeight{
    return 100;
}

-(UIView*)alignView{
    return self.label;
}

-(CGFloat)alignOffset{
    return 20;
}
@end
