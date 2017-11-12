#ifndef CAPTUREHELPER_H
#define CAPTUREHELPER_H

#include <QtCore/QObject>
#include <QtQuick/QQuickItem>

class CaptureHelper : public QObject
{
    Q_OBJECT

public:
    explicit CaptureHelper(QObject *parent = 0);
    virtual ~CaptureHelper();

    Q_INVOKABLE bool captureQuickItem(QQuickItem *item);
};

#endif // CAPTUREHELPER_H
