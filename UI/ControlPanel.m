#import <UIKit/UIKit.h>

extern UIView *panel;

void createControlPanel() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    panel = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 250, 300)];
    panel.backgroundColor = [UIColor blackColor];
    panel.layer.cornerRadius = 15;
    panel.hidden = YES;

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(80, 240, 100, 40);
    [close setTitle:@"إغلاق" forState:UIControlStateNormal];

    [close addTarget:nil action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];

    [panel addSubview:close];
    [window addSubview:panel];
}

void togglePanel() {
    panel.hidden = !panel.hidden;
}

void closePanel() {
    panel.hidden = YES;
}
