//
//  HeaderView.m
//  XiaoDongDemo2
//
//  Created by Story5 on 15/12/17.
//  Copyright © 2015年 Story5. All rights reserved.
//

#import "HeaderView.h"
#import "ScaleHelper.h"
@implementation HeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];

        float originX = ScalePx(31);
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, self.frame.size.width - originX, self.frame.size.height)];
        [self addSubview:self.textLabel];

    }
    return self;
}

- (void)dealloc
{
    if (_textLabel) {
        [_textLabel release];
        _textLabel = nil;
    }
    
    [super dealloc];
}


@end
