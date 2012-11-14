#include <QDeclarativeContext>

#include "csapplication.h"
#include "qmlapplicationviewer.h"
#include "capturehelper.h"

int main(int argc, char *argv[])
{
    CSApplication        app(argc, argv);
    QmlApplicationViewer viewer;
    CaptureHelper        capture_helper;

    viewer.rootContext()->setContextProperty("CSApplication", &app);
    viewer.rootContext()->setContextProperty("CaptureHelper", &capture_helper);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#ifdef MEEGO_TARGET
    viewer.setMainQmlFile(QLatin1String("qml/christmastree/Meego/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/christmastree/Symbian/main.qml"));
#endif
    viewer.showFullScreen();

    return app.exec();
}
