//
//  InviteGroupCellView.m
//  WeChatPlugin
//
//  Created by wentian on 17/04/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import "InviteGroupCellView.h"
#import "TKWeChatPluginConfig.h"

@interface InviteGroupCellView ()

@property (nonatomic, strong) NSText *name;

@end

@implementation InviteGroupCellView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.name = ({
        NSText *v = [[NSText alloc] init];
        v.editable = NO;
        v.frame = NSMakeRect(0, 15, 400, 20);
        v.layer.cornerRadius = 10;
        v.layer.masksToBounds = YES;
        v.textColor = [NSColor blackColor];
        v.backgroundColor = [NSColor clearColor];
        [v.layer setNeedsDisplay];
        
        v;
    });
    
    self.textField.enabled = false;
    
    [self addSubview:self.name];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    _name.string = [NSString stringWithFormat:@"%@ %@", _data[@"name"], _data[@"user"]];
}


@end
