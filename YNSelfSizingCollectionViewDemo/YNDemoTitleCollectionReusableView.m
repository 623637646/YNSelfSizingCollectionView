//
//  YNDemoTitleCollectionReusableView.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/3/13.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoTitleCollectionReusableView.h"

@interface YNDemoTitleCollectionReusableView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoTitleCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:30];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:label];
        [self addConstraints:({
            NSMutableArray<NSLayoutConstraint *> *constraint = [[NSMutableArray<NSLayoutConstraint *> alloc] init];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:00]];
            
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
@end
