//
//  RecentCityCell.m
//  XiaoDongDemo2
//
//  Created by Story5 on 15/12/17.
//  Copyright © 2015年 Story5. All rights reserved.
//

#import "RecentCityCell.h"

@implementation RecentCityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1;
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
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
