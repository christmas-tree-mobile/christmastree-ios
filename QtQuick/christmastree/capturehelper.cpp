#include <QImage>
#include <QPainter>
#include <QStyleOptionGraphicsItem>
#include <QDateTime>
#include <QDir>
#include <QDesktopServices>

#include "capturehelper.h"

CaptureHelper::CaptureHelper(QObject *parent) : QObject(parent)
{
}

CaptureHelper::~CaptureHelper()
{
}

bool CaptureHelper::captureDeclarativeItem(QDeclarativeItem *item)
{
    if (item != NULL) {
        QImage                   image(item->boundingRect().size().toSize(), QImage::Format_ARGB32_Premultiplied);
        QPainter                 painter(&image);
        QStyleOptionGraphicsItem style_option;

        style_option.exposedRect = item->boundingRect();

        item->paint(&painter, &style_option, NULL);

        QList<QDeclarativeItem*> sorted_children;

        for (int i = 0; i < item->children().size(); i++) {
            QDeclarativeItem *child = dynamic_cast<QDeclarativeItem*>(item->children().at(i));

            if (child != NULL) {
                if (sorted_children.size() == 0) {
                    sorted_children.append(child);
                } else {
                    int j;

                    for (j = 0; j < sorted_children.size(); j++) {
                        if (sorted_children.at(j)->zValue() > child->zValue()) {
                            sorted_children.insert(j, child);

                            break;
                        }
                    }

                    if (j == sorted_children.size()) {
                        sorted_children.append(child);
                    }
                }
            }
        }

        for (int i = 0; i < sorted_children.size(); i++) {
            QDeclarativeItem *child = sorted_children.at(i);

            painter.save();

            painter.translate(child->x(), child->y());

            style_option.exposedRect = child->boundingRect();

            child->paint(&painter, &style_option, NULL);

            painter.restore();
        }

        QString file_path = QDesktopServices::storageLocation(QDesktopServices::PicturesLocation);
        QString file_name = "ChristmasTree-" + QDateTime::currentDateTime().toString("dd.MM.yyyy.hh.mm.ss") + ".jpg";

        if (QDir::root().mkpath(file_path) && image.save(file_path + QDir::separator() + file_name)) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}
