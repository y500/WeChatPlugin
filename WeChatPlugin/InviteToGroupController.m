//
//  InviteToGroupController.m
//  WeChatPlugin
//
//  Created by wentian on 17/04/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import "InviteToGroupController.h"
#import "InviteGroupCellView.h"
#import "WeChatHelper.h"
#import "TKWeChatPluginConfig.h"

@interface InviteToGroupController () <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) NSButton *enableMagicButton;

@property (nonatomic, strong) NSText *inviteGroupID;

@property (nonatomic, strong) NSTableView *tableView;

@property (nonatomic, strong) NSArray *groupList;

@end

@implementation InviteToGroupController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self setup];
    [self initSubviews];
    
    NSMutableArray *chatRooms = [NSMutableArray arrayWithCapacity:1];
    
    NSInteger selectedIndex = -1, index = 0;
    NSArray *groupContact = [WeChatHelper groupList];
    for (WCContactData *contact in groupContact) {
        if ([contact.m_nsUsrName hasSuffix:@"chatroom"]) {
            NSMutableDictionary *room = [NSMutableDictionary dictionaryWithCapacity:1];
            [room setObject:contact.m_nsUsrName?:@"" forKey:@"user"];
            [room setObject:contact.m_nsNickName?:@"" forKey:@"name"];
            [room setObject:contact.m_nsHeadImgUrl?:@"" forKey:@"avatar"];
            [chatRooms addObject:room];
            
            if ([contact.m_nsUsrName isEqualToString:[TKWeChatPluginConfig sharedConfig].inviteGroupID]) {
                selectedIndex = index;
            }
            index++;
        }
    }
    self.groupList = chatRooms;
     [_tableView reloadData];
    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedIndex] byExtendingSelection:YES];
}

- (void)initSubviews {
    
    self.enableMagicButton = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:@"选择自动拉群的群组" target:self action:@selector(clickEnabelInviteGroup:)];
        btn.frame = NSMakeRect(30, self.window.contentView.frame.size.height - 30, 200, 20);
        btn.state = [TKWeChatPluginConfig sharedConfig].enabelInviteToGroup;
        
        btn;
    });
    
    self.inviteGroupID = ({
        NSText *text = [[NSText alloc] initWithFrame:NSMakeRect(300, _enableMagicButton.frame.origin.y, 280, 20)];
        text.backgroundColor = [NSColor clearColor];
        text.textColor = [NSColor systemYellowColor];
        text.string = [TKWeChatPluginConfig sharedConfig].inviteGroupID;
        text;
    });
    
    [self.window.contentView addSubviews:@[self.enableMagicButton, self.inviteGroupID]];
    
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.frame = NSMakeRect(30, 10, self.window.contentView.frame.size.width - 50, self.window.contentView.frame.size.height - 50);
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        scrollView;
    });
    
    self.tableView = ({
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = NSMakeRect(0, 0, scrollView.frame.size.width, scrollView.frame.size.height - 30);
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        NSTableColumn *column = [[NSTableColumn alloc] init];
        column.title = @"自动拉群设置";
        column.width = 400;
        [tableView addTableColumn:column];
        
        tableView;
    });
    
    scrollView.contentView.documentView = self.tableView;
    [self.window.contentView addSubview:scrollView];
}

- (void)setup {
    self.window.contentView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.window.contentView.layer setNeedsDisplay];
}

/**
 关闭窗口事件
 
 */
- (BOOL)windowShouldClose:(id)sender {
    return YES;
}

- (void)clickEnabelInviteGroup:(NSButton*)button {
    [TKWeChatPluginConfig sharedConfig].enabelInviteToGroup = button.state;
}

#pragma mark - NSTableViewDataSource && NSTableViewDelegate

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.groupList.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    InviteGroupCellView *cell = [[InviteGroupCellView alloc] init];
    cell.frame = NSMakeRect(0, 0, 480, 50);
    cell.data = _groupList[row];
    
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    NSString *groupID = _groupList[row][@"user"];
    [[TKWeChatPluginConfig sharedConfig] setInviteGroupID:groupID];
    [tableView reloadData];
    
    _inviteGroupID.string = groupID;
    
    return YES;
}

@end
