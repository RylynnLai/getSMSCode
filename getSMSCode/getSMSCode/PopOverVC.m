//
//  PopOverVC.m
//  getSMSCode
//
//  Created by LLZ on 2018/1/25.
//  Copyright © 2018年 LLZ. All rights reserved.
//

#import "PopOverVC.h"
#import "Controller.h"
#import "ViewModel.h"

@interface PopOverVC ()<NSTabViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSSegmentedControl *segmentedController;
@property (weak) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) NSImageView *emptyView;
@property (nonatomic, strong) NSProgressIndicator *indicator;

@end

@implementation PopOverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[Controller shareController].viewModel addObserver:self forKeyPath:NSStringFromSelector(@selector(smsCodes)) options:NSKeyValueObservingOptionNew context:nil];
    [[Controller shareController] addObserver:self forKeyPath:NSStringFromSelector(@selector(isRequesting)) options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.indicator];
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    [self refresh:nil];
}

- (IBAction)segmentAction:(NSSegmentedControl *)sender {
    ProjectType type = (ProjectType)sender.selectedSegment;
    [[Controller shareController] checkSMSCodeWithProjecttype:type];
}
- (IBAction)refresh:(NSButton *)sender {
    [self segmentAction:self.segmentedController];
}
- (IBAction)quitAction:(NSButton *)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(smsCodes))]) {
        if ([Controller shareController].viewModel.smsCodes.count == 0) {
            [self.view addSubview:self.emptyView];
        } else {
            [self.emptyView removeFromSuperview];
        }
        [self.tableView reloadData];
    } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(isRequesting))]) {
        self.indicator.hidden = ![Controller shareController].isRequesting;
    }
    
}
- (NSImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [NSImageView imageViewWithImage:[NSImage imageNamed:@"empty"]];
        CGRect rect = CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4, self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
        _emptyView.frame = rect;
    }
    return _emptyView;
}

- (NSProgressIndicator *)indicator
{
    if (!_indicator) {
        _indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(20, self.view.bounds.size.height - 25, 20, 20)];
        [_indicator setStyle:NSProgressIndicatorStyleSpinning];
        [_indicator startAnimation:nil];
    }
    return _indicator;
}

- (void)dealloc
{
    [[Controller shareController].viewModel removeObserver:self forKeyPath:NSStringFromSelector(@selector(smsCodes))];
    [[Controller shareController] removeObserver:self forKeyPath:NSStringFromSelector(@selector(isRequesting))];
}
#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [Controller shareController].viewModel.smsCodes.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSInteger index = 0;
    if ([Controller shareController].viewModel.smsCodes.count > row) {
        index = row;
    } else {
        index = [Controller shareController].viewModel.smsCodes.count;
    }
    SMSCodeModel *smsCode = [Controller shareController].viewModel.smsCodes[index];
    NSString *strIdt = [tableColumn identifier];
    NSTableCellView *cell = [tableView makeViewWithIdentifier:strIdt owner:self];
    cell.textField.stringValue = [smsCode valueForKey:strIdt];

    return cell;
}

@end
