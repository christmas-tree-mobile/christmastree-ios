#ifndef CAPTUREHELPER_H
#define CAPTUREHELPER_H

#include <QObject>
#include <QDeclarativeItem>

class CaptureHelper : public QObject
{
    Q_OBJECT

public:
    explicit CaptureHelper(QObject *parent = 0);
    virtual ~CaptureHelper();

    Q_INVOKABLE bool captureDeclarativeItem(QDeclarativeItem *item);
};

#endif // CAPTUREHELPER_H
