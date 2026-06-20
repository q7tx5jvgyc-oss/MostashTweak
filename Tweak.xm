#import "UI/FloatingButton.h"
#import "UI/ControlPanel.h"

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        createFloatingButton();
        createControlPanel();
    });
}

%end
