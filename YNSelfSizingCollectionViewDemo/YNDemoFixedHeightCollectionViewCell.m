//
//  YNDemoFixedHeightCollectionViewCell.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/3/13.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoFixedHeightCollectionViewCell.h"

@interface YNDemoFixedHeightCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoFixedHeightCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:30];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:label];
        [self.contentView addConstraints:({
            NSMutableArray<NSLayoutConstraint *> *constraint = [[NSMutableArray<NSLayoutConstraint *> alloc] init];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
            
            constraint;
        })];
        self.label = label;
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    self.label.text = title;
    [self setNeedsUpdateConstraints];
}

-(YNSelfSizingCollectionViewCellType) type{
    return YNSelfSizingCollectionViewCellTypeFixedHeight;
}

-(CGFloat)fixedHeight{
    return 100;
}

-(UIView*)alignView{
    return self.label;
}

-(CGFloat)alignOffset{
    return 0;
}
@end