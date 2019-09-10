#import <UIKit/UIKit.h>

#include <QtCore/QDir>
#include <QtCore/QStandardPaths>

#include "sharehelper.h"

ShareHelper::ShareHelper(QObject *parent) : QObject(parent)
{
}

ShareHelper &ShareHelper::GetInstance()
{
    static ShareHelper instance;

    return instance;
}

QString ShareHelper::imageFilePath() const
{
    QString tmp_dir = QStandardPaths::writableLocation(QStandardPaths::TempLocation);

    if (tmp_dir != QStringLiteral("")) {
        QDir().mkpath(tmp_dir);
    }

    return QDir(tmp_dir).filePath(QStringLiteral("image.jpg"));
}

void ShareHelper::showShareToView(const QString &image_path)
{
    UIViewController * __block root_view_controller = nil;

    [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
        root_view_controller = window.rootViewController;

        *stop = (root_view_controller != nil);
    }];

    if (@available(iOS 8, *)) {
        UIActivityViewController *activity_view_controller = [[[UIActivityViewController alloc] initWithActivityItems:@[[NSURL fileURLWithPath:image_path.toNSString()]] applicationActivities:nil] autorelease];

        activity_view_controller.excludedActivityTypes      = @[];
        activity_view_controller.completionWithItemsHandler = ^(UIActivityType, BOOL, NSArray *, NSError *) {
            emit shareToViewCompleted();
        };

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            activity_view_controller.popoverPresentationController.sourceView = root_view_controller.view;
        }

        [root_view_controller presentViewController:activity_view_controller animated:YES completion:nil];
    } else {
        assert(0);
    }
}
