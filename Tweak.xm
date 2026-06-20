#import <UIKit/UIKit.h>

static UIView *floatingButton;
static UIView *panel;
static BOOL panelVisible = NO;

static UIWindow *getKeyWindow() {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        if (scene.activationState != UISceneActivationStateForegroundActive) continue;

        UIWindowScene *ws = (UIWindowScene *)scene;

        for (UIWindow *w in ws.windows) {
            if (w.isKeyWindow) return w;
        }
    }
    return nil;
}

static void togglePanel() {
    panelVisible = !panelVisible;
    panel.hidden = !panelVisible;
}

static void createUI() {

    UIWindow *window = getKeyWindow();
    if (!window) return;

    // ===== Floating Button =====
    floatingButton = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 60, 60)];
    floatingButton.backgroundColor = UIColor.systemBlueColor;
    floatingButton.layer.cornerRadius = 30;

    UILabel *label = [[UILabel alloc] initWithFrame:floatingButton.bounds];
    label.text = @"M";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;

    [floatingButton addSubview:label];

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:nil action:@selector(togglePanel)];

    [floatingButton addGestureRecognizer:tap];

    [window addSubview:floatingButton];

    // ===== Panel =====
    panel = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 250, 220)];
    panel.backgroundColor = UIColor.blackColor;
    panel.layer.cornerRadius = 12;
    panel.hidden = YES;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    title.text = @"MOSTASH PANEL";
    title.textColor = UIColor.whiteColor;

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(70, 150, 100, 40);
    [close setTitle:@"Close" forState:UIControlStateNormal];

    [close addTarget:nil action:@selector(dummy) forControlEvents:UIControlEventTouchUpInside];

    [close addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        panel.hidden = YES;
        panelVisible = NO;
    }] forControlEvents:UIControlEventTouchUpInside];

    [panel addSubview:title];
    [panel addSubview:close];

    [window addSubview:panel];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        createUI();
    });
}

%end
