#import <UIKit/UIKit.h>

UIView *panel;

void createControlPanel() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    panel = [[UIView alloc] initWithFrame:CGRectMake(60, 250, 260, 300)];
    panel.backgroundColor = [UIColor blackColor];
    panel.layer.cornerRadius = 15;
    panel.alpha = 0.9;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    title.text = @"Control Panel";
    title.textColor = UIColor.whiteColor;

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(80, 240, 100, 40);
    [close setTitle:@"Close" forState:UIControlStateNormal];

    [close addTarget:nil action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];

    [panel addSubview:title];
    [panel addSubview:close];

    panel.hidden = YES;

    [window addSubview:panel];
}

void togglePanel() {
    panel.hidden = !panel.hidden;
}

void closePanel() {
    panel.hidden = YES;
}
